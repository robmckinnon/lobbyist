class RegisterEntry < ActiveRecord::Base

  belongs_to :data_source
  belongs_to :organisation

  has_many :office_contacts, :dependent => :delete_all
  has_many :consultancy_staff_members, :dependent => :delete_all
  has_many :consultancy_clients, :order=>'name', :dependent => :delete_all
  has_many :monitoring_clients, :order=>'name', :dependent => :delete_all

  delegate :period_start, :to => :data_source
  delegate :period_end, :to => :data_source

  validates_presence_of :data_source
  validates_presence_of :organisation_name

  before_validation :set_consultancy_clients
  before_validation :set_monitoring_clients
  before_validation :set_consultancy_staff_members
  before_validation :set_organisation

  validates_associated :office_contacts, :message=>"are invalid, they can't be blank"
  validates_associated :consultancy_clients
  validates_associated :monitoring_clients
  validates_associated :consultancy_staff_members

  after_update :save_consultancy_clients, :save_monitoring_clients, :save_consultancy_staff_members, :save_office_contacts

  class << self
    def clean_text text
      text.sub('•','').sub("􀂃",'').sub(/^\*/,'').strip.squeeze(' ')
    end

    def clean_name text
      text.strip.chomp(';').strip.chomp('.').strip.chomp(',').strip.chomp(':').strip.chomp(' (').strip
    end

    def clean_names client
      a,b = RegisterEntry.get_names client.name
      if b.blank?
        client.name = RegisterEntry.clean_name(client.name)
      else
        client.name = RegisterEntry.clean_name(a)
        client.name_in_parentheses = RegisterEntry.clean_name(b)
      end
    end

    def valid_name? text
      !text.blank? && !text[/^None$/i] && !text[/^N\/A$/i]
    end

    def get_names text
      name = text[/^(.+)\s\(([^\(]+)\)\.?$/,1]
      if name && name.size <= 256
        name_in_parentheses = text[/^(.+)\s\(([^\(]+)\)\.?$/,2]
      else
        name = text[/^(.+)\s(comprising.+)$/,1]
        if name && name.size <= 256
          name_in_parentheses = text[/^(.+)\s(comprising.+)$/,2]
        elsif text.size > 256
          length = text.size
          index = [text.index(',') ? text.index(',') : length, text.index('(') ? text.index('(') : length].min

          name = text[0..index]
          name_in_parentheses = text[index..(text.length)].sub(/^, /,'')
        else
          name = text
          name_in_parentheses = nil
        end
      end
      return name, name_in_parentheses
    end
  end

  def consultancy_staff_members_text
    if @consultancy_staff_members_text
      @consultancy_staff_members_text
    else
      consultancy_staff_members.blank? ? '' : consultancy_staff_members.collect(&:name).join("\n")
    end
  end

  def consultancy_clients_text
    if @consultancy_clients_text
      @consultancy_clients_text
    else
      consultancy_clients.blank? ? '' : consultancy_clients.collect(&:name).join("\n")
    end
  end

  def monitoring_clients_text
    if @monitoring_clients_text
      @monitoring_clients_text
    else
      monitoring_clients.blank? ? '' : monitoring_clients.collect(&:name).join("\n")
    end
  end

  def consultancy_staff_members_text= text
    @consultancy_staff_members_text = text
  end

  def consultancy_clients_text= text
    @consultancy_clients_text = text
  end

  def monitoring_clients_text= text
    @monitoring_clients_text = text
  end

  def new_monitoring_client_attributes=(monitoring_client_attributes)
    monitoring_client_attributes.each do |attributes|
      monitoring_clients.build(attributes)
    end
  end

  def new_office_contact_attributes=(office_contact_attributes)
    office_contact_attributes.each do |attributes|
      office_contacts.build(attributes)
    end
  end

  def existing_office_contact_attributes=(office_contact_attributes)
    office_contacts.reject(&:new_record?).each do |office_contact|
      attributes = office_contact_attributes[office_contact.id.to_s]
      if attributes
        office_contact.attributes = attributes
      else
        office_contacts.delete(office_contact)
      end
    end
  end

  def existing_consultancy_client_attributes=(consultancy_client_attributes)
    consultancy_clients.reject(&:new_record?).each do |consultancy_client|
      attributes = consultancy_client_attributes[consultancy_client.id.to_s]
      if attributes
        consultancy_client.attributes = attributes
      else
        consultancy_clients.delete(consultancy_client)
      end
    end
  end

  def existing_monitoring_client_attributes=(monitoring_client_attributes)
    monitoring_clients.reject(&:new_record?).each do |monitoring_client|
      attributes = monitoring_client_attributes[monitoring_client.id.to_s]
      if attributes
        monitoring_client.attributes = attributes
      else
        monitoring_clients.delete(monitoring_client)
      end
    end
  end

  def existing_consultancy_staff_member_attributes=(consultancy_staff_member_attributes)
    consultancy_staff_members.reject(&:new_record?).each do |consultancy_staff_member|
      attributes = consultancy_staff_member_attributes[consultancy_staff_member.id.to_s]
      if attributes
        consultancy_staff_member.attributes = attributes
      else
        consultancy_staff_members.delete(consultancy_staff_member)
      end
    end
  end

  private

    def set_consultancy_staff_members
      if @consultancy_staff_members_text
        begin
          @consultancy_staff_members_text.each_line do |text|
            text = text.strip.squeeze(' ')
            consultancy_staff_members.build("name"=>text) unless text.blank?
          end
          @consultancy_staff_members_text = nil
        rescue
        end
      end
    end

    def set_consultancy_clients
      if @consultancy_clients_text
        begin
          @consultancy_clients_text.each_line do |text|
            text = RegisterEntry.clean_name(text)
            if RegisterEntry.valid_name?(text)
              name, name_in_parentheses = RegisterEntry.get_names text
              consultancy_clients.build("name"=>name, "name_in_parentheses"=>name_in_parentheses)
            end
          end
          @consultancy_clients_text = nil
        rescue
        end
      end
    end

    def set_monitoring_clients
      if @monitoring_clients_text
        begin
          @monitoring_clients_text.each_line do |text|
            text = RegisterEntry.clean_name(text)
            if RegisterEntry.valid_name?(text)
              name, name_in_parentheses = RegisterEntry.get_names text
              monitoring_clients.build("name"=>name, "name_in_parentheses"=>name_in_parentheses)
            end
          end
          @monitoring_clients_text = nil
        rescue
        end
      end
    end

    def save_consultancy_clients
      consultancy_clients.each do |consultancy_client|
        consultancy_client.save(false)
      end
    end

    def save_monitoring_clients
      monitoring_clients.each do |monitoring_client|
        monitoring_client.save(false)
      end
    end

    def save_consultancy_staff_members
      consultancy_staff_members.each do |consultancy_staff_member|
        consultancy_staff_member.save(false)
      end
    end

    def save_office_contacts
      office_contacts.each do |office_contact|
        office_contact.save(false)
      end
    end

    def set_organisation
      if organisation_name && !organisation_url.blank?
        org = Organisation.find_or_create_from_url_and_name(organisation_url, organisation_name)
        self.organisation_id = org.id
      end
    end
end
