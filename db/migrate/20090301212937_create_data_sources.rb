class CreateDataSources < ActiveRecord::Migration
  def self.up
    create_table :data_sources do |t|
      t.string :name
      t.string :url
      t.integer :organisation_id

      t.timestamps
    end

    add_index :data_sources, :organisation_id
  end

  def self.down
    drop_table :data_sources
  end
end
