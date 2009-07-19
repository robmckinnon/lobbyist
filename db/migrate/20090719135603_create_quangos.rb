class CreateQuangos < ActiveRecord::Migration
  def self.up
    create_table :quangos do |t|
      t.string :name
      t.string :name_in_brackets
      t.string :alternate_name
      t.string :acronym
      t.string :quango_type
      t.string :focus
      t.string :url
      t.string :source
      t.boolean :dormant
      t.integer :organisation_id
      t.integer :government_department_id

      t.timestamps
    end
    
    add_index :quangos, :quango_type
    add_index :quangos, :name
    add_index :quangos, :organisation_id
    add_index :quangos, :government_department_id
  end

  def self.down
    drop_table :quangos
  end
end
