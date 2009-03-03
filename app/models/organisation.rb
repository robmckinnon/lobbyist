class Organisation < ActiveRecord::Base

  has_friendly_id :name, :use_slug => true, :strip_diacritics => true

  has_many :data_sources

  has_many :register_entries

  has_many :consultancy_clients
  has_many :monitoring_clients

  validates_presence_of :name
  validates_uniqueness_of :name

  validates_presence_of :url
end
