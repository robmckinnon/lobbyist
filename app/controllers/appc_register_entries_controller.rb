class AppcRegisterEntriesController < ApplicationController

  before_filter :set_data_sources, :only => [:new, :edit]
  before_filter :store_location, :only => [:index, :new, :edit]

  def new
    @appc_register_entry = AppcRegisterEntry.new
  end

  def create
    entry = params['appc_register_entry']
    @appc_register_entry = AppcRegisterEntry.create_register_entry(entry['data_source_id'], entry['data'])
    redirect_to :action=>'index', :controller=>'register_entries'
  end

end
