class CreateCompanySearches < ActiveRecord::Migration
  def self.up
    create_table :company_searches do |t|
      t.string :term

      t.timestamps
    end

    add_index :company_searches, :term
  end

  def self.down
    remove_index :company_searches, :term

    drop_table :company_searches
  end
end
