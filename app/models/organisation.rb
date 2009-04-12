require 'acts_as_wikipedia'
require 'open-uri'
require 'uri'
require 'morph'

class Organisation < ActiveRecord::Base

  acts_as_wikipedia

  has_friendly_id :name, :use_slug => true, :strip_diacritics => true

  has_many :data_sources
  has_many :register_entries
  has_many :consultancy_clients
  has_many :monitoring_clients

  validates_presence_of :name
  validates_uniqueness_of :name

  # validates_presence_of :url
  validates_uniqueness_of :url, :allow_nil => true

  before_validation :populate_company_number

  class << self
    def find_or_create_from_url_and_name url, name
      url = url.chomp('/')
      if exists?(:url => url)
        find_by_url(url)
      else
        create!(:url => url, :name => name)
      end
    end

    def all_with_matches_at_top organisation
      first_name = organisation.name.split.first
      organisations = all.sort do |a, b|
        if a.name[/^#{first_name}/i]
          if b.name[/^#{first_name}/i]
            a.name <=> b.name
          else
            -1
          end
        elsif b.name[/^#{first_name}/i]
          +1
        else
          a.name <=> b.name
        end
      end
      organisations.delete(organisation)
      organisations
    end
  end

  def find_similarly_named name_part
    organisations = Organisation.find(:all, :conditions => %Q|name like "#{name_part} %"|) +
        Organisation.find(:all, :conditions => %Q|name like "#{name_part}-%"|) +
        Organisation.find(:all, :conditions => %Q|name like "The #{name_part} %"|) +
        Organisation.find(:all, :conditions => %Q|name like "The #{name_part}-%"|) +
        Organisation.find(:all, :conditions => %Q|name like "#{name_part}"|)
    organisations.delete(self)
    organisations.sort_by{|x| x.name.gsub('-',' ')}
  end

  def name_part name, count=1
    parts = name.split(/( |-)/)
    first_name = parts.first
    first_name = parts[2] if parts.first == 'The'
    if count==1
      first_name
    else
      (parts.first == 'The') ? "#{first_name}#{parts[3]}#{parts[4]}" : "#{first_name}#{parts[1]}#{parts[2]}"
    end
  end

  def normalize_name_part part
    puts part.gsub('-',' ').gsub('&','and')
    part.gsub('-',' ').gsub('&','and')
  end

  def similarly_named
    part = name_part(name)
    organisations = find_similarly_named(part)

    if organisations.size > 9
      normalized = normalize_name_part(name_part(name,2))
      name_parts = (organisations + [self]).collect{|x| name_part(x.name,2) }.uniq
      name_parts.delete_if{|x| normalize_name_part(x) != normalized}
      organisations = name_parts.collect {|name_part| find_similarly_named(name_part)}.flatten.uniq
    end
    organisations
  end

  def is_lobbyist_firm?
    !register_entries.empty?
  end

  def merge_with_id= organisation_id
    # handled in OrganisationsController
  end

  def merge_with_id
    nil
  end

  def merge! organisation
    if organisation.id
      data_sources.each {|x| x.organisation_id = organisation.id; x.save! }
      register_entries.each {|x| x.organisation_id = organisation.id; x.save!}
      consultancy_clients.each {|x| x.organisation_id = organisation.id; x.save!}
      monitoring_clients.each {|x| x.organisation_id = organisation.id; x.save!}
      destroy
    end
  end

  private
    def set_company company
      puts "setting company to: #{company.name}"
      self.company_number = company.company_number
      self.registered_name = company.name
    end

    def company_is_a_match? company
      puts company.name
      upcase_name = name.upcase
      company.name == upcase_name || company.name[/^(.+) (LIMITED|LTD)\.?$/,1] == upcase_name
    end

    def handle_company_results results
      result_size = results.result_size.to_i
      puts ""
      puts "#{name}: #{result_size} matches"

      if result_size == 1
        set_company(results.company) if company_is_a_match?(results.company)
      elsif result_size > 1
        results.companies.each do |company|
          set_company(company) if company_is_a_match?(company)
        end
      end
    end

    def populate_company_number
      begin
        encoded_name = URI.encode(name)
        # url = "http://localhost:3001/search?q=#{encoded_name}&f=xml"
        url = "http://companiesrevealed.org/search?q=#{encoded_name}&f=xml"
        xml = open(url).read.gsub("id>","companies_revealed_id>")
        hash = Hash.from_xml(xml)
        results = Morph.from_hash(hash)
        handle_company_results(results)
      rescue Exception => e
        puts "#{Exception.class.name} while populating company for '#{name}': #{e.to_s}"
      end
    end
end
