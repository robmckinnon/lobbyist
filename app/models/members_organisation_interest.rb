class MembersOrganisationInterest < ActiveRecord::Base

  belongs_to :organisation
  belongs_to :members_interests_item

end
