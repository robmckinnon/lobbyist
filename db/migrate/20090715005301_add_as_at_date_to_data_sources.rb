class AddAsAtDateToDataSources < ActiveRecord::Migration
  def self.up
    add_column :data_sources, :as_at_date, :date
  end

  def self.down
    remove_column :data_sources, :as_at_date
  end
end
