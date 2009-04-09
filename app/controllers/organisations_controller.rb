class OrganisationsController < ApplicationController

  before_filter :find_organisation, :only => [:show, :edit]
  before_filter :store_location, :only => [:index]

  def index
    @organisations = Organisation.find(:all, :order => "name")
  end

  def new
    @organisation = Organisation.new
  end

  def show
    @register_entries = @organisation.register_entries
    @consultancy_clients = @organisation.consultancy_clients
  end

  def edit
    @organisations = Organisation.all_with_matches_at_top(@organisation)
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

    merge_with_id = params[:organisation][:merge_with_id]

    if !merge_with_id.blank? && organisation = Organisation.find(merge_with_id)
      @organisation.merge!(organisation)
      flash[:notice] = "Successfully merged #{@organisation.name} into #{organisation.name}."
      redirect_to organisation_path(organisation)
    elsif @organisation.update_attributes(params[:organisation])
      flash[:notice] = "Successfully updated #{@organisation.name}."
      redirect_to organisations_path
    else
      render :action => 'edit'
    end
  end

  private

    def find_organisation
      begin
        @organisation = Organisation.find(params[:id])
        redirect_to @organisation, :status => :moved_permanently if @organisation.has_better_id?
      rescue
        render_not_found
      end
    end

end
