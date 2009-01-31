require File.dirname(__FILE__) + '/../spec_helper'

describe Appointee do

  assert_model_has_many :former_roles
  assert_model_has_many :appointments

end
