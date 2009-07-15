class CreateMembersInterestsCategories < ActiveRecord::Migration
  def self.up
    create_table :members_interests_categories do |t|
      t.integer :number
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :members_interests_categories
  end
end
