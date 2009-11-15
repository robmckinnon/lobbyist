class OrganisationGroupMember < ActiveRecord::Base

  belongs_to :organisation
  belongs_to :organisation_group

  def organisation_name
    organisation.name
  end
end
