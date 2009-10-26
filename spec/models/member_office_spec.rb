require File.dirname(__FILE__) + '/../spec_helper'

describe MemberOffice do

  assert_model_belongs_to :member

  describe 'when asked if current' do

    it 'should return true if to_date is nil' do
      office = MemberOffice.new
      office.current?.should be_true
    end

    it 'should return true if to_date is not nil and in past' do
      office = MemberOffice.new :to_date => Date.parse('2009-01-01')
      office.current?.should be_false
    end
  end
end
