class OrganisationGroupMember < ActiveRecord::Base

  belongs_to :organisation
  belongs_to :organisation_group

end
