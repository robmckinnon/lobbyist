class MonitoringClient < ActiveRecord::Base

  belongs_to :register_entry
  belongs_to :organisation

  validates_presence_of :name

  before_validation :set_organisation

  private
    def set_organisation
      if organisation_id.nil? && !name.blank?
        org = Organisation.find_or_create_by_name(name)
        self.organisation_id = org.id
      end
    end
end
