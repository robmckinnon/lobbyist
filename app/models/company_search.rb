class CompanySearch < ActiveRecord::Base

  has_many :company_search_results, :dependent => :delete_all

  has_many :companies, :through => :company_search_results, :source => :company

  validates_uniqueness_of :term

end
