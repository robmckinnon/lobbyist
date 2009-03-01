class CreatePeople < ActiveRecord::Migration

  def self.up
    create_table :people do |t|
      t.string :name
      t.string :wikipedia_url
      t.string :spinwatch_url
      t.timestamps
    end
  end

  def self.down
    drop_table :people
  end

end
