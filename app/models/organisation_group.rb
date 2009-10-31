class OrganisationGroup < ActiveRecord::Base

  has_many :organisation_group_members
  belongs_to :sic_uk_class

end
