class CreateSpecialAdvisorAppointingMinisters < ActiveRecord::Migration
  def self.up
    create_table :special_advisor_appointing_ministers do |t|
      t.string :title
      t.integer :special_advisor_list_id

      t.timestamps
    end

    add_index :special_advisor_appointing_ministers, :special_advisor_list_id,
        :name => 'index_appointing_ministers_on_special_advisor_list_id'
  end

  def self.down
    drop_table :special_advisor_appointing_ministers
  end
end
