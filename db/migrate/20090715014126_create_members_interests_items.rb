class CreateMembersInterestsItems < ActiveRecord::Migration
  def self.up
    create_table :members_interests_items do |t|
      t.integer :members_interests_category_id
      t.integer :members_interests_entry_id
      t.string :subcategory
      t.text :description
      t.string :range_amount_text
      t.string :actual_amount_text
      t.string :up_to_amount_text
      t.string :from_amount_text
      t.integer :actual_amount
      t.integer :up_to_amount
      t.integer :from_amount
      t.string :currency_symbol
      t.string :registered_date_text
      t.date :registered_date
      
      t.timestamps
    end
    
    add_index :members_interests_items, :members_interests_category_id
    add_index :members_interests_items, :members_interests_entry_id
  end

  def self.down
    drop_table :members_interests_items
  end
end
