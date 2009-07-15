class AddPublicwhipPersonIdToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :publicwhip_id, :string
    
    add_index :people, :publicwhip_id
  end

  def self.down
    remove_column :people, :publicwhip_id
  end
end
