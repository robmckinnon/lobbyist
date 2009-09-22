class AddIndexToPersonName < ActiveRecord::Migration
  def self.up
    add_index :people, :name
  end

  def self.down
    remove_index :people, :name
  end
end
