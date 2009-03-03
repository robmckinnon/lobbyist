class CreateOrganisations < ActiveRecord::Migration
  def self.up
    create_table :organisations do |t|
      t.string :name
      t.string :url
      t.string :wikipedia_url
      t.string :spinwatch_url
      t.integer :company_number

      t.timestamps
    end
  end

  def self.down
    drop_table :organisations
  end
end
