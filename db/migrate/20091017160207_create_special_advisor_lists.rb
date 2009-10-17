class CreateSpecialAdvisorLists < ActiveRecord::Migration
  def self.up
    create_table :special_advisor_lists do |t|
      t.date :at_date
      t.integer :data_source_id

      t.timestamps
    end

    add_index :special_advisor_lists, :data_source_id
  end

  def self.down
    drop_table :special_advisor_lists
  end
end
