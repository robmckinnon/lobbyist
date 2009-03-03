class ConsultancyStaffMember < ActiveRecord::Base

  belongs_to :register_entry
  belongs_to :person

  validates_presence_of :name

end
