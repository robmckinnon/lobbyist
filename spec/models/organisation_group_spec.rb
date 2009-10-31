require File.dirname(__FILE__) + '/../spec_helper'

describe OrganisationGroup do

  assert_model_has_many :organisation_group_members
  assert_model_belongs_to :sic_uk_class

end
