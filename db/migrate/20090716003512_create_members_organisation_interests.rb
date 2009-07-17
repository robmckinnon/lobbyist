class CreateMembersOrganisationInterests < ActiveRecord::Migration
  def self.up
    create_table :members_organisation_interests do |t|
      t.integer :organisation_id
      t.integer :members_interests_item_id

      t.timestamps
    end
    
    add_index :members_organisation_interests, :organisation_id
    add_index :members_organisation_interests, :members_interests_item_id, :name => 'index_organisation_interests_on_members_interests_item_id'
  end

  def self.down
    drop_table :members_organisation_interests
  end
end
