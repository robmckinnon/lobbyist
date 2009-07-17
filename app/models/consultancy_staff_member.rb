class ConsultancyStaffMember < ActiveRecord::Base

  belongs_to :register_entry
  belongs_to :person

  validates_presence_of :name

  def consultancy
    register_entry.organisation_name
  end
  
  def dates
    [register_entry.data_source.period_start, register_entry.data_source.period_end]
  end
end
