class AppointeesController < ApplicationController

  layout "application", :except => :get_person_name

  before_filter :set_people, :only => [:new, :edit]
  before_filter :set_data_sources, :only => [:new, :edit]
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
      set_people_and_data_sources
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
      set_people_and_data_sources
      render :action => 'edit'
    end
  end

  private

    def set_people_and_data_sources
      set_people @appointee.person_id
      set_data_sources @appointee.data_source_id
    end

    def set_data_sources data_source_id=session[:data_source_id]
      @data_source = nil
      if data_source_id
        begin
          session[:data_source_id] = nil
          @data_source = DataSource.find(data_source_id)
        rescue
        end
      end
      @data_sources = DataSource.find(:all, :order => "name") || []
    end

    def set_people person_id=session[:person_id]
      @person = nil
      if person_id
        begin
          session[:person_id] = nil
          @person = Person.find(person_id)
        rescue
        end
      end
      @people = Person.find(:all, :order => "name") || []
    end
end
