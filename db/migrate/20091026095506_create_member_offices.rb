class CreateMemberOffices < ActiveRecord::Migration
  def self.up
    create_table :member_offices do |t|
      t.string :name
      t.string :department
      t.string :position
      t.string :publicwhip_id
      t.string :publicwhip_member_id
      t.integer :member_id
      t.date :from_date
      t.date :to_date
      t.string :source

      t.timestamps
    end

    add_index :member_offices, :publicwhip_id
    add_index :member_offices, :publicwhip_member_id
    add_index :member_offices, :member_id
    add_index :member_offices, :department
  end

  def self.down
    drop_table :member_offices
  end
end
