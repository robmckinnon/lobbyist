class CreateMembersInterestsEntries < ActiveRecord::Migration
  def self.up
    create_table :members_interests_entries do |t|
      t.integer :member_id
      t.integer :data_source_id

      t.timestamps
    end

    add_index :members_interests_entries, :member_id
    add_index :members_interests_entries, :data_source_id
  end

  def self.down
    drop_table :members_interests_entries
  end
end
