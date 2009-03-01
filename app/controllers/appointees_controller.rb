class AppointeesController < ApplicationController

  layout "application", :except => :get_person_name

  before_filter :set_people, :only => [:new, :edit]
  before_filter :store_location, :only => [:new, :edit]

  def get_person_name
    person_id = params[:appointee][:person_id]
    unless person_id.blank?
      person = Person.find(person_id)
      @person_name = person.name
    else
      @person_name = ''
    end
  end

  def index
    @appointees = Appointee.all
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
      render :action => 'new'
    end
  end

  def update
    @appointee = Appointee.find(params[:id])
    params[:appointee][:existing_former_role_attributes] ||= {}
    params[:appointee][:existing_appointment_attributes] ||= {}

    if @appointee.update_attributes(params[:appointee])
      flash[:notice] = "Successfully updated project, former roles and appointments."
      redirect_to appointees_path
      # redirect_to appointee_path(@appointee)
    else
      render :action => 'edit'
    end
  end

  private

    def set_people
      @person = nil
      if person_id = session[:person_id]
        begin
          session[:person_id] = nil
          @person = Person.find(person_id)
        rescue
        end
      end
      @people = Person.find(:all, :order => "name") || []
    end
end
