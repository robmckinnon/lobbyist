class AppcRegisterReportsController < ApplicationController

  before_filter :set_data_sources, :only => [:new, :edit]
  before_filter :store_location, :only => [:index, :new, :edit]

  def new
    @appc_register_report = AppcRegisterReport.new
  end

  def create
    data_source_id = params['appc_register_report']['data_source_id']
    data = params['appc_register_report']['data']

    if data_source_id.blank?
      flash[:notice] = "data_source_id can't be blank"
      set_data_sources
      render :new
    elsif data.blank?
      flash[:notice] = "data can't be blank"
      set_data_sources
      render :new
    else
      @appc_register_report = AppcRegisterReport.new
      @appc_register_report.data_source_id = data_source_id
      @appc_register_report.data = data

      count = 0
      register_entries = @appc_register_report.register_entries
      register_entries.each do |entry|
        identifiers = {:data_source_id=>entry.data_source_id, :organisation_name=>entry.organisation_name}
        unless RegisterEntry.exists?(identifiers)
          entry.save!
          count = count + 1
        end
      end

      flash[:notice] = "created #{count} register entries"
      redirect_to :action=>'index', :controller=>'register_entries'
    end
  end
end
