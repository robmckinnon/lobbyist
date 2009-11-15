class AddNameInParenthesesToConsultancyStaffMember < ActiveRecord::Migration
  def self.up
    add_column :consultancy_staff_members, :name_in_parentheses, :string
  end

  def self.down
    remove_column :consultancy_staff_members, :name_in_parentheses
  end
end
