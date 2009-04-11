class AddNameIndexes < ActiveRecord::Migration
  def self.up
    add_index :organisations, :name
    add_index :monitoring_clients, :name
    add_index :consultancy_clients, :name
  end

  def self.down
  end
end
