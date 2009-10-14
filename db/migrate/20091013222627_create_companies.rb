class CreateCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies do |t|
      t.string :name
      t.string :company_number
      t.text :address
      t.string :url
      t.string :wikipedia_url
      t.string :company_category
      t.string :company_status
      t.date :incorporation_date
      t.string :country_code, :limit => 2
      t.timestamps
    end

    add_index :companies, :company_number
    add_index :companies, :name
    add_index :companies, :url
    add_index :companies, :company_category
    add_index :companies, :company_status
    add_index :companies, :country_code

    add_column :company_classifications, :company_id, :integer
    add_index :company_classifications, :company_id
  end

  def self.down
    remove_index :company_classifications, :company_id
    remove_column :company_classifications, :company_id
    drop_table :companies
  end
end
