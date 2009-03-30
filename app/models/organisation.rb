require 'acts_as_wikipedia'
require 'open-uri'
require 'uri'
require 'morph'

class Organisation < ActiveRecord::Base

  acts_as_wikipedia

  has_friendly_id :name, :use_slug => true, :strip_diacritics => true

  has_many :data_sources

  has_many :register_entries

  has_many :consultancy_clients
  has_many :monitoring_clients

  validates_presence_of :name
  validates_uniqueness_of :name

  validates_presence_of :url
  validates_uniqueness_of :url

  before_validation :populate_company_number

  private
    def populate_company_number
      encoded_name = URI.encode name.gsub('&','AND')
      url = "http://localhost:3001/search?q=#{encoded_name}&f=xml"
      xml = open(url).read.gsub("id>","companies_revealed_id>")
      hash = Hash.from_xml(xml)
      results = Morph.from_hash(hash)
      y results
      if results.result_size.to_i == 0
      elsif results.result_size.to_i == 1
        self.company_number = results.company.company_number
      elsif results.result_size.to_i > 1
      end
      puts results.result_size
    end
end
