class AddDataSourceToAppointee < ActiveRecord::Migration
  def self.up
    add_column :appointees, :data_source_id, :integer

    add_index :appointees, :data_source_id
  end

  def self.down
    remove_column :appointees, :data_source_id
  end
end
