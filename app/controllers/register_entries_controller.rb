class RegisterEntriesController < ApplicationController

  before_filter :set_data_sources, :only => [:new, :edit]
  before_filter :set_organisations, :only => [:new, :edit]
  before_filter :store_location, :only => [:index, :new, :edit]

  def index
    @register_entries = RegisterEntry.find(:all, :order => "organisation_name")
  end

  def show
    @register_entry = RegisterEntry.find(params[:id])
  end

  def new
    @register_entry = RegisterEntry.new
    @register_entry.office_contacts.build
    @register_entry.consultancy_staff_members.build
    @register_entry.consultancy_clients.build
    @register_entry.monitoring_clients.build
  end

  def create
    @register_entry = RegisterEntry.new(params[:register_entry])
    if @register_entry.save
      flash[:notice] = "Successfully created register entry."
      redirect_to register_entries_path
    else
      set_organisations_and_data_sources
      render :action => 'new'
    end
  end

  def update
    @register_entry = RegisterEntry.find(params[:id])
    params[:register_entry][:existing_office_contact_attributes] ||= {}
    params[:register_entry][:existing_consultancy_staff_member_attributes] ||= {}
    params[:register_entry][:existing_consultancy_client_attributes] ||= {}
    params[:register_entry][:existing_monitoring_client_attributes] ||= {}

    if @register_entry.update_attributes(params[:register_entry])
      flash[:notice] = "Successfully updated entry for #{@register_entry.organisation_name}."
      redirect_to register_entries_path
    else
      set_organisations_and_data_sources
      render :action => 'edit'
    end
  end

  def edit
    @register_entry = RegisterEntry.find(params[:id])
  end

  private

    def set_organisations_and_data_sources
      set_organisations @register_entry.organisation_id
      set_data_sources @register_entry.data_source_id
    end

end
