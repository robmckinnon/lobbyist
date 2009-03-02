class OrganisationsController < ApplicationController

  def index
    @organisations = Organisation.all
  end

  def new
    @organisation = Organisation.new
  end

  def show
  end

  def edit
  end

  def create
    @organisation = Organisation.new(params[:organisation])
    if @organisation.save
      session[:organisation_id] = @organisation.id
      redirect_back_or_default organisations_path
    else
      render :action => :new
    end
  end

  def update
    @organisation = Organisation.find(params[:id])

    if @organisation.update_attributes(params[:organisation])
      flash[:notice] = "Successfully updated #{@organisation.name}."
      redirect_to organisations_path
    else
      render :action => 'edit'
    end
  end
end
