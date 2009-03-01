class PeopleController < ApplicationController

  before_filter :find_person, :only => [:show, :edit]
  before_filter :ensure_current_person_url, :only => :show

  def index
    @people = Person.all
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

  private

    def find_person
      begin
        appointees = {:appointees => [:former_roles, :appointments]}
        @person = Person.find(params[:id], :include => appointees)
        redirect_to @person, :status => :moved_permanently if @person.has_better_id?
      rescue
        render_not_found
      end
    end

    def ensure_current_person_url
      redirect_to @person, :status => :moved_permanently if @person.has_better_id?
    end

end
