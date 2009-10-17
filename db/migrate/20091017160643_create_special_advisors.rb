class CreateSpecialAdvisors < ActiveRecord::Migration
  def self.up
    create_table :special_advisors do |t|
      t.string :name
      t.string :qualification
      t.integer :special_advisor_list_id
      t.integer :special_advisor_appointing_minister_id

      t.timestamps
    end

    add_index :special_advisors, :special_advisor_list_id
    add_index :special_advisors, :special_advisor_appointing_minister_id
  end

  def self.down
    drop_table :special_advisors
  end
end
