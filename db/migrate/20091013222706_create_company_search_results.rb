class CreateCompanySearchResults < ActiveRecord::Migration
  def self.up
    create_table :company_search_results do |t|
      t.integer :company_search_id
      t.integer :company_id
      t.timestamps
    end

    add_index :company_search_results, :company_search_id
    add_index :company_search_results, :company_id
  end

  def self.down
    remove_index :company_search_results, :company_search_id
    remove_index :company_search_results, :company_id

    drop_table :company_search_results
  end
end
