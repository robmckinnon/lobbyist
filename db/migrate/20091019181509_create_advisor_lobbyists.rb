class CreateAdvisorLobbyists < ActiveRecord::Migration
  def self.up
    create_table :advisor_lobbyists do |t|
      t.integer :special_advisor_id
      t.integer :consultancy_staff_member_id
      t.timestamps
    end

    add_index :advisor_lobbyists, :special_advisor_id
    add_index :advisor_lobbyists, :consultancy_staff_member_id
  end

  def self.down
    drop_table :advisor_lobbyists
  end
end
