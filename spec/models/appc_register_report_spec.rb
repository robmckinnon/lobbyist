require File.dirname(__FILE__) + '/../spec_helper'

describe AppcRegisterReport do

  describe 'when data is set' do
    before do
      @appc_register_report = AppcRegisterReport.new
      @organisation_name = 'Advocate Policy & Public Affairs Consulting Ltd'
      @description = 'APPC Register Entry for 1 September 2008 to 30 November 2008'
      @url = 'http://www.advocate-consulting.co.uk'
      @organisation_name2 = 'APCO Worldwide'
      @description2 = 'APPC Register Entry for 1 September 2008 to 30 November 2008'
      @url2 = 'http://www.apcoworldwide.com/uk'

      @data_source_id = '5'
      @data = "#{@organisation_name}
#{@description}
Website: #{@url}
#{@organisation_name2}
#{@description2}
Website: #{@url2}"
    end

    it 'should create RegisterEntry correctly' do
      @appc_register_report.data_source_id = @data_source_id
      @appc_register_report.data = @data

      @appc_register_report.register_entries.size.should == 2

      register_entry = @appc_register_report.register_entries[0]
      register_entry.organisation_name.should == @organisation_name
      register_entry.data_source_id.should == @data_source_id.to_i
      register_entry.organisation_url.should == @url

      register_entry = @appc_register_report.register_entries[1]
      register_entry.organisation_name.should == @organisation_name2
      register_entry.data_source_id.should == @data_source_id.to_i
      register_entry.organisation_url.should == @url2
    end
  end

end
