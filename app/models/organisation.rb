class Organisation < ActiveRecord::Base

  has_friendly_id :name, :use_slug => true, :strip_diacritics => true

  has_many :data_sources

  validates_presence_of :name
  validates_uniqueness_of :name

end
