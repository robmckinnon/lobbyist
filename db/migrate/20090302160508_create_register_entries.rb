class CreateRegisterEntries < ActiveRecord::Migration
  def self.up
    create_table :register_entries do |t|
      t.string :organisation_name
      t.string :organisation_url
      t.integer :organisation_id
      t.integer :data_source_id
      t.string :declaration_signed_or_submitted
      t.text :offices_outside_the_uk

      t.timestamps
    end

    add_index :register_entries, :data_source_id
    add_index :register_entries, :organisation_id
  end

  def self.down
    drop_table :register_entries
  end
end
