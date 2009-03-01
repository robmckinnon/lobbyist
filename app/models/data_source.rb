class DataSource < ActiveRecord::Base

  has_friendly_id :name, :use_slug => true, :strip_diacritics => true

  belongs_to :organisation

  has_many :appointees

end
