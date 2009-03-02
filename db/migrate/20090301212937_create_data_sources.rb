class CreateDataSources < ActiveRecord::Migration
  def self.up
    create_table :data_sources do |t|
      t.string :name
      t.string :long_name
      t.string :url
      t.integer :organisation_id
      t.date :period_start
      t.date :period_end

      t.timestamps
    end

    add_index :data_sources, :organisation_id
  end

  def self.down
    drop_table :data_sources
  end
end
