class CreateGovernmentDepartments < ActiveRecord::Migration
  def self.up
    create_table :government_departments do |t|
      t.string :name
      t.string :url

      t.timestamps
    end
  end

  def self.down
    drop_table :government_departments
  end
end
