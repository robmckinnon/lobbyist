class CreateOrganisations < ActiveRecord::Migration
  def self.up
    create_table :organisations do |t|
      t.string :name
      t.string :alternate_name
      t.string :url
      t.string :wikipedia_url
      t.string :spinwatch_url
      t.string :company_number
      t.string :registered_name

      t.timestamps
    end

  end

  def self.down
    drop_table :organisations
  end
end
