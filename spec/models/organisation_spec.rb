require File.dirname(__FILE__) + '/../spec_helper'

describe Organisation do

  assert_model_has_many :data_sources
  assert_model_has_many :register_entries
  assert_model_has_many :consultancy_clients
  assert_model_has_many :monitoring_clients

  describe 'when asked to merge with another organisation' do
    before do
      @neg_plc_id = 123
      @neg_plc = Organisation.new :name => 'National Express Group PLC'
      @neg_plc.stub!(:id).and_return @neg_plc_id
      @neg = Organisation.new :name => 'National Express Group'
      @neg.stub!(:destroy)
    end

    def check_ids_reset attribute
      item = mock('Item')
      @neg.stub!(attribute).and_return [item]
      item.should_receive(:organisation_id=).with(@neg_plc_id)
      item.should_receive(:save!)
      @neg.merge!(@neg_plc)
    end

    it "should link organisation's data_source to merged organisation" do
      check_ids_reset :data_sources
    end

    it "should link organisation's register_entries to merged organisation" do
      check_ids_reset :register_entries
    end

    it "should link organisation's consultancy_clients to merged organisation" do
      check_ids_reset :consultancy_clients
    end

    it "should link organisation's monitoring_clients to merged organisation" do
      check_ids_reset :monitoring_clients
    end

    it 'should delete organisation' do
      @neg.should_receive(:destroy)
      @neg.merge!(@neg_plc)
    end
  end

end
