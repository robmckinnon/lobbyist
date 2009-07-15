class AddFileToDataSources < ActiveRecord::Migration
  def self.up
    add_column :data_sources, :file, :string
  end

  def self.down
    add_column :data_sources, :file
  end
end
