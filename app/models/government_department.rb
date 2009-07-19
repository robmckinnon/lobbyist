class GovernmentDepartment < ActiveRecord::Base

  validates_uniqueness_of :name

  has_many :quangos

end
