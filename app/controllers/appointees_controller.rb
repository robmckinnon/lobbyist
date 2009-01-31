class AppointeesController < ActionController::Base

  layout "application"

  def index
    @appointees = Appointee.all
  end

  def new
    @appointee = Appointee.new
    @appointee.former_roles.build
    @appointee.appointments.build
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

  def edit
    @appointee = Appointee.find(params[:id])
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
end
