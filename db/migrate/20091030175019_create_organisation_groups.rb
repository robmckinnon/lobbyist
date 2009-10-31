class CreateOrganisationGroups < ActiveRecord::Migration
  def self.up
    create_table :organisation_groups do |t|
      t.string  :name
      t.integer :sic_uk_class_id
      t.integer :sic_uk_class_code
      t.string  :sic_uk_section_code
      t.string  :url
      t.string  :wikipedia_url
      t.string  :spinprofiles_url

      t.timestamps
    end

    add_index :organisation_groups, :sic_uk_class_id
    add_index :organisation_groups, :sic_uk_class_code
    add_index :organisation_groups, :sic_uk_section_code
  end

  def self.down
    drop_table :organisation_groups
  end
end
