class Person < ActiveRecord::Base

  has_friendly_id :name, :use_slug => true, :strip_diacritics => true

  has_many :appointees
  has_many :former_roles, :through => :appointees
  has_many :appointments, :through => :appointees

  validates_presence_of :name
  validates_uniqueness_of :name

end
