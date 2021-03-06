class AppointeesController < ApplicationController

  before_filter :set_people, :only => [:new, :edit]
  before_filter :set_data_sources, :only => [:new, :edit]
  before_filter :set_organisations, :only => [:new, :edit]
  before_filter :store_location, :only => [:index, :new, :edit]

  def index
    @appointees = Appointee.find(:all, :order => "name")
  end

  def show
    @appointee = Appointee.find(params[:id])
  end

  def new
    @appointee = Appointee.new
    @appointee.former_roles.build
    @appointee.appointments.build
    @appointee.appointments.first.organisation_id = nil
  end

  def edit
    @appointee = Appointee.find(params[:id])
  end

  def create
    @appointee = Appointee.new(params[:appointee])
    if @appointee.save
      flash[:notice] = "Successfully created appointee, former roles and appointments."
      redirect_to appointees_path
    else
      set_people_and_data_sources_and_organisations
      render :action => 'new'
    end
  end

  def update
    @appointee = Appointee.find(params[:id])
    params[:appointee][:existing_former_role_attributes] ||= {}
    params[:appointee][:existing_appointment_attributes] ||= {}

    if @appointee.update_attributes(params[:appointee])
      flash[:notice] = "Successfully updated #{@appointee.name}."
      redirect_to appointees_path
    else
      set_people_and_data_sources_and_organisations
      render :action => 'edit'
    end
  end

  private

    def set_people_and_data_sources_and_organisations
      set_people @appointee.person_id
      set_data_sources @appointee.data_source_id
      set_organisations nil
    end
end
