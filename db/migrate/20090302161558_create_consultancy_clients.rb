class CreateConsultancyClients < ActiveRecord::Migration
  def self.up
    create_table :consultancy_clients do |t|
      t.string :name
      t.text :name_in_parentheses
      t.integer :organisation_id
      t.integer :register_entry_id

      t.timestamps
    end

    add_index :consultancy_clients, :organisation_id
    add_index :consultancy_clients, :register_entry_id
  end

  def self.down
    drop_table :consultancy_clients
  end
end
