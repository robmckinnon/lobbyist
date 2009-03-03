class OfficeContact < ActiveRecord::Base

  belongs_to :register_entry

  validates_presence_of :details

end
