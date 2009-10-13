class CreateCompanyClassifications < ActiveRecord::Migration
  def self.up
    create_table :company_classifications do |t|
      t.integer :organisation_id
      t.integer :sic_uk_class_id

      t.timestamps
    end

    add_index :company_classifications, :organisation_id
    add_index :company_classifications, :sic_uk_class_id
  end

  def self.down
    drop_table :company_classifications
  end
end
