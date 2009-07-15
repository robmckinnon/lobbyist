class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.integer :person_id
      t.string :publicwhip_id
      t.string :house
      t.string :title
      t.string :firstname
      t.string :lastname
      t.string :constituency
      t.string :party
      t.date :from_date
      t.date :to_date
      t.string :from_why
      t.string :to_why

      t.timestamps
    end
    
    add_index :members, :person_id
    add_index :members, :publicwhip_id
    add_index :members, :party
  end

  def self.down
    drop_table :members
  end
end
