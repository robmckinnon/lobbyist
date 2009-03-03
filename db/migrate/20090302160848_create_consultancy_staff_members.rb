class CreateConsultancyStaffMembers < ActiveRecord::Migration
  def self.up
    create_table :consultancy_staff_members do |t|
      t.string :name
      t.integer :person_id
      t.integer :register_entry_id

      t.timestamps
    end

    add_index :consultancy_staff_members, :person_id
    add_index :consultancy_staff_members, :register_entry_id
  end

  def self.down
    drop_table :consultancy_staff_members
  end
end
