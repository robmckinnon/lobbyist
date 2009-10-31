class CreateOrganisationGroupMembers < ActiveRecord::Migration
  def self.up
    create_table :organisation_group_members do |t|
      t.integer :organisation_group_id
      t.integer :organisation_id

      t.timestamps
    end

    add_index :organisation_group_members, :organisation_id
    add_index :organisation_group_members, :organisation_group_id
  end

  def self.down
    drop_table :organisation_group_members
  end
end
