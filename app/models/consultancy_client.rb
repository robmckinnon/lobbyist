class ConsultancyClient < ActiveRecord::Base

  belongs_to :register_entry
  belongs_to :organisation

  validates_presence_of :name

end
