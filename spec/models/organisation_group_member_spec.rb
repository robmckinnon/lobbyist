require File.dirname(__FILE__) + '/../spec_helper'

describe OrganisationGroupMember do

  assert_model_belongs_to :organisation
  assert_model_belongs_to :organisation_group

end
