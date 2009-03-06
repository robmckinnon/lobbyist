class AppcRegisterEntriesController < ApplicationController

  before_filter :set_data_sources, :only => [:new, :edit]
  before_filter :store_location, :only => [:index, :new, :edit]

  def new
    @appc_register_entry = AppcRegisterEntry.new
  end

  def create
    @appc_register_entry = AppcRegisterEntry.new
    @appc_register_entry.data_source_id = params['appc_register_entry']['data_source_id']
    @appc_register_entry.data = params['appc_register_entry']['data']

    register_entry = @appc_register_entry.register_entry
    register_entry.save!

    redirect_to :action=>'index', :controller=>'register_entries'
  end
end
