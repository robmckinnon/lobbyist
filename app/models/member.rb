class Member < ActiveRecord::Base
  
  belongs_to :person

  validates_uniqueness_of :publicwhip_id, :allow_nil => true

end
