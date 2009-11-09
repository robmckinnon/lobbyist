require 'acts_as_wikipedia'
require 'open-uri'
require 'uri'
require 'morph'

class Organisation < ActiveRecord::Base

  acts_as_wikipedia

  has_friendly_id :name, :use_slug => true, :strip_diacritics => true

  has_one :quango

  has_many :data_sources
  has_many :register_entries
  has_many :consultancy_clients
  has_many :monitoring_clients
  has_many :appointments

  has_many :members_organisation_interests
  has_many :members_interests_items, :through => :members_organisation_interests

  has_many :company_classifications, :dependent => :delete_all
  has_many :sic_uk_classes, :through => :company_classifications

  validates_presence_of :name
  validates_uniqueness_of :name

  # validates_presence_of :url
  validates_uniqueness_of :url, :allow_nil => true

  before_validation :populate_company_number
  after_save :save_classifications

  class << self

    def recommended_limited_merges
      organisations = Organisation.all
      ltds = organisations.select{|x| x.name[/ltd$/i]} ; nil
      limiteds = organisations.select{|x| x.name[/limited$/i]} ; nil
      grouped = (ltds + limiteds).group_by {|x| x.name.sub(/ltd$/i,'').sub(/limited$/i,'').strip }
      duplicates = grouped.values.select {|x| x.size > 1}.sort_by{|x| x.first.name}
      duplicates = duplicates.collect do |companies|
        companies.sort_by {|x| x.name[/#{x.registered_name}/i] ? 1 : 0}
      end
      duplicates
    end

    def quangos
      Quango.find(:all, :include => :organisation).collect(&:organisation)
    end

    def find_or_create_from_url_and_name url, name
      url = url.chomp('/') unless url.blank?
      url = nil if url.blank?
      if !url.nil? && exists?(:url => url)
        find_by_url(url)
      elsif exists?(:name => name)
        find_by_name(name)
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

  def next_organisation_with_similarly_named
    organisation = next_organisation
    while (organisation && organisation.similarly_named.empty?)
      organisation = organisation.next_organisation
    end
    organisation
  end

  def next_organisation
    next_id = self.id + 1
    last_id = Organisation.last.id
    while next_id <= last_id && !Organisation.exists?(next_id)
      next_id += 1
    end
    if next_id > last_id
      nil
    else
      Organisation.find(next_id)
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
    if first_name == 'Association'
      name[/Association\s(of|for)\s\w+/]
    elsif count == 1
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

  def set_organisation_ids collection, organisation
    collection.each {|item| item.organisation_id = organisation.id, item.save! }
  end

  def merge! organisation
    if organisation.id
      if quango
        quango.organisation_id = organisation.id; quango.save!
      end
      set_organisation_ids data_sources, organisation
      set_organisation_ids register_entries, organisation
      set_organisation_ids consultancy_clients, organisation
      set_organisation_ids monitoring_clients, organisation
      set_organisation_ids appointments, organisation
      set_organisation_ids members_organisation_interests, organisation

      company_classifications.each do |classificiation|
        classificiation.organisation_id = nil
        classificiation.save!
      end

      destroy
    end
  end

  def consultancy_entries_by_lobbyist_firm
    entries = entries_by_lobbyist_firm consultancy_clients
    return [sort_by_name(entries.keys), entries]
  end

  def monitoring_entries_by_lobbyist_firm
    entries = entries_by_lobbyist_firm monitoring_clients
    return [sort_by_name(entries.keys), entries]
  end

  def entries_by_consultancy_staff_member2
    entries = entries_by_client_organisation :consultancy_staff_members, nil
    return [sort_by_name(entries.keys), entries]
  end

  def entries_by_consultancy_staff_member
    entries = entries_by_client_organisation :consultancy_staff_members, :name
    return [entries.keys.sort, entries]
  end

  def consultancy_entries_by_client_organisation
    entries = entries_by_client_organisation :consultancy_clients
    return [sort_by_name(entries.keys), entries]
  end

  def monitoring_entries_by_client_organisation
    entries = entries_by_client_organisation :monitoring_clients
    return [sort_by_name(entries.keys), entries]
  end

  def company
    if company_number
      Company.find_by_company_number(company_number)
    else
      nil
    end
  end

  private

    def sort_by_name list
      list.sort_by {|x| x.name.to_s.downcase}
    end

    def entries_by_lobbyist_firm clients
      entries_by_lobbyist_firm = clients.collect(&:register_entry).group_by(&:organisation)
      entries_by_lobbyist_firm.each {|k,v| entries_by_lobbyist_firm[k] = v.sort_by{|x| x.data_source.period_start} }
      entries_by_lobbyist_firm
    end

    def entries_by_client_organisation client_type, entity_type=:organisation
      entries_by_client = Hash.new {|h,k| h[k] = []}
      register_entries.each do |entry|
        entry.send(client_type).each do |client|
          key = entity_type ? client.send(entity_type) : client
          entries_by_client[key] << entry
        end
      end
      entries_by_client.each {|k,v| entries_by_client[k] = v.sort_by{|x| x.data_source.period_start} }
      entries_by_client
    end

    def save_classifications
      if company_number
        company = Company.find_by_company_number(company_number)
        if company
          company.company_classifications.each do |classification|
            if classification.organisation_id
              unless classification.organisation_id == self.id
                new_classification = classification.clone
                new_classification.organisation_id = self.id
                puts "cloning: #{new_classification.inspect}"
                new_classification.save!
              end
            else
              classification.organisation_id = self.id
              puts "setting: #{classification.inspect}"
              classification.save!
            end
          end
        end
      end
    end

    def set_company company
      puts "setting company to: #{company.name}"
      self.company_number = company.company_number
      self.registered_name = company.name
    end

    def populate_company_number
      unless company_number
        company = Company.find_match(name)
        set_company(company) if company
      end
    end
end
