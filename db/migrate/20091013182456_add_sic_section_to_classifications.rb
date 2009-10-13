class AddSicSectionToClassifications < ActiveRecord::Migration
  def self.up
    add_column :company_classifications, :sic_uk_class_code, :integer
    add_column :company_classifications, :sic_uk_section_code, :string

    add_index :company_classifications, :sic_uk_class_code
    add_index :company_classifications, :sic_uk_section_code
  end

  def self.down
    remove_column :company_classifications, :sic_uk_section_code
    remove_column :company_classifications, :sic_uk_class_code
  end
end
