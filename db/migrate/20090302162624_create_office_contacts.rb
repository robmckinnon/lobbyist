class CreateOfficeContacts < ActiveRecord::Migration
  def self.up
    create_table :office_contacts do |t|
      t.integer :register_entry_id
      t.text :details

      t.timestamps
    end

    add_index :office_contacts, :register_entry_id
  end

  def self.down
    drop_table :office_contacts
  end
end
