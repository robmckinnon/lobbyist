require File.dirname(__FILE__) + '/../spec_helper'

describe Appointment do

  assert_model_belongs_to :appointee

end
