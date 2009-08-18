class CreateLords < ActiveRecord::Migration
  def self.up
    create_table :lords do |t|
      t.integer :person_id
      t.string :publicwhip_id
      t.string :house
      t.string :forenames
      t.string :forenames_full
      t.string :surname
      t.string :title
      t.string :lord_name
      t.string :lord_of_name
      t.string :lord_of_name_full
      t.string :county
      t.string :peerage_type
      t.string :affiliation
      t.boolean :ex_mp
      t.string :from_why
      t.string :to_why
      t.integer :from_year
      t.date :from_date
      t.date :to_date

      t.timestamps
    end

    add_index :lords, :person_id
    add_index :lords, :publicwhip_id
    add_index :lords, :affiliation
    add_index :lords, :title
    add_index :lords, :lord_name
    add_index :lords, :lord_of_name
    add_index :lords, :lord_of_name_full
  end

  def self.down
    drop_table :lords
  end
end
