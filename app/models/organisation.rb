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
        if a.name.starts_with?(first_name)
          if b.name.starts_with?(first_name)
            a.name <=> b.name
          else
            -1
          end
        elsif b.name.starts_with?(first_name)
          +1
        else
          a.name <=> b.name
        end
      end
      organisations.delete(organisation)
      organisations
    end
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
    def populate_company_number
      begin
        encoded_name = URI.encode name.gsub('&','AND')
        # url = "http://localhost:3001/search?q=#{encoded_name}&f=xml"
        url = "http://companiesrevealed.org/search?q=#{encoded_name}&f=xml"
        xml = open(url).read.gsub("id>","companies_revealed_id>")
        hash = Hash.from_xml(xml)
        results = Morph.from_hash(hash)
        y results
        if results.result_size.to_i == 0
        elsif results.result_size.to_i == 1
          self.company_number = results.company.company_number
        elsif results.result_size.to_i > 1
        end
        puts results.result_size
      rescue Exception => e
        puts e.to_s
      end
    end
end
