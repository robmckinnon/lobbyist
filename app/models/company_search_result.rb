class CompanySearchResult < ActiveRecord::Base

  belongs_to :company_search
  belongs_to :company

end
