class OfficeContact < ActiveRecord::Base

  belongs_to :register_entry

  validates_presence_of :details

  def display_details
    details.gsub(/(Name|Tel|Fax|Email):\n/,'')
  end
end
