class PeopleController < ApplicationController

  before_filter :find_person, :only => [:show, :edit]
  before_filter :ensure_current_person_url, :only => :show
  before_filter :store_location, :only => [:index]

  def index
    @people = Person.find(:all, :order => "name")
    @mps, @mp_details = Person.current_mps
    @others = @people - @mps
  end

  def show
  end

  def edit
  end

  def new
    @person = Person.new
  end

  def create
    @person = Person.new(params[:person])
    if @person.save
      session[:person_id] = @person.id
      redirect_back_or_default people_path
    else
      render :action => :new
    end
  end

  def update
    @person = Person.find(params[:id])

    if @person.update_attributes(params[:person])
      flash[:notice] = "Successfully updated #{@person.name}."
      redirect_to people_path
    else
      render :action => 'edit'
    end
  end

  private

    def find_person
      begin
        appointees = {:appointees => [:former_roles, :appointments]}
        @person = Person.find(params[:id], :include => [:members, appointees])
        redirect_to @person, :status => :moved_permanently if @person.has_better_id?
      rescue
        render_not_found
      end
    end

    def ensure_current_person_url
      redirect_to @person, :status => :moved_permanently if @person.has_better_id?
    end

end
