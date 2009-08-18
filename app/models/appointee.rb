class Appointee < ActiveRecord::Base

  belongs_to :person
  belongs_to :data_source

  has_many :former_roles, :dependent => :destroy
  has_many :appointments, :dependent => :destroy

  validates_presence_of :name
  validates_presence_of :person

  validates_associated :former_roles, :message=>'are invalid, one or more dates may be wrong, or titles may be missing'
  validates_associated :appointments

  after_update :save_former_roles, :save_appointments

  class << self
    def parse_date text
      if text
        begin
          Date.parse text
        rescue
          nil
        end
      else
        nil
      end
    end
    
    def create_from name, person, data
      appointee = find_or_create_by_name_and_person_id :name => name, :person_id => person.id

      if title = data[:former_role]
        attributes = { :title => title,
            :leaving_service_date => parse_date(data[:month_of_leaving_office]) }

        unless appointee.former_roles.find(:first, :conditions => attributes)
          appointee.former_roles.create attributes
        end
      end

      if role = data[:appointment]
        organisation_name = data[:organisation]
        puts appointee.inspect unless organisation_name
        organisation = Organisation.find_or_create_from_url_and_name nil, organisation_name.chomp('.')
        attributes = { :title => role,
            :organisation_name => organisation_name,
            :organisation_id => organisation.id,
            :acoba_advice => data[:advice],
            :date_tendered => parse_date(data[:tendered]),
            :date_taken_up => parse_date(data[:taken_up]) }
        unless appointee.appointments.find(:first, :conditions => attributes)
          appointee.appointments.create attributes
        end
      end
    end
  end
  
  def new_former_role_attributes=(former_role_attributes)
    former_role_attributes.each do |attributes|
      former_roles.build(attributes)
    end
  end

  def new_appointment_attributes=(appointment_attributes)
    appointment_attributes.each do |attributes|
      appointments.build(attributes)
    end
  end

  def existing_former_role_attributes=(former_role_attributes)
    former_roles.reject(&:new_record?).each do |former_role|
      attributes = former_role_attributes[former_role.id.to_s]
      if attributes
        former_role.attributes = attributes
      else
        former_roles.delete(former_role)
      end
    end
  end

  def existing_appointment_attributes=(appointment_attributes)
    appointments.reject(&:new_record?).each do |appointment|
      attributes = appointment_attributes[appointment.id.to_s]
      if attributes
        appointment.attributes = attributes
      else
        appointments.delete(appointment)
      end
    end
  end

  def save_former_roles
    former_roles.each do |former_role|
      former_role.save(false)
    end
  end

  def save_appointments
    appointments.each do |appointment|
      appointment.save(false)
    end
  end

end
