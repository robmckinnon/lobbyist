class DataSourcesController < ApplicationController

  before_filter :find_data_source, :only => [:show, :edit]
  before_filter :ensure_current_data_source_url, :only => :show
  before_filter :set_organisations, :only => [:new, :edit]
  before_filter :store_location, :only => [:index]
  before_filter :store_second_location, :only => [:new, :edit]

  def index
    @data_sources = DataSource.find(:all, :order => "name")
  end

  def new
    @data_source = DataSource.new
  end

  def show
  end

  def edit
  end

  def create
    @data_source = DataSource.new(params[:data_source])
    if @data_source.save
      session[:data_source_id] = @data_source.id
      redirect_back_or_default data_sources_path
    else
      set_organisations @data_source.organisation_id
      render :action => :new
    end
  end

  def update
    @data_source = DataSource.find(params[:id])

    if @data_source.update_attributes(params[:data_source])
      flash[:notice] = "Successfully updated #{@data_source.name}."
      redirect_to data_sources_path
    else
      set_organisations @data_source.organisation_id
      render :action => 'edit'
    end
  end

  private

    def store_second_location
      unless @organisation
        session[:second_return_to] = session[:return_to]
        session[:return_to] = request.request_uri
      end
    end

    def set_organisations organisation_id=session[:organisation_id]
      @organisation = nil
      if organisation_id
        begin
          session[:organisation_id] = nil
          @organisation = Organisation.find(organisation_id)
        rescue
        end
      end
      @organisations = Organisation.find(:all, :order => "name") || []
    end

    def find_data_source
      begin
        @data_source = DataSource.find(params[:id])
        redirect_to @data_source, :status => :moved_permanently if @data_source.has_better_id?
      rescue
        render_not_found
      end
    end

    def ensure_current_data_source_url
      redirect_to @data_source, :status => :moved_permanently if @data_source.has_better_id?
    end
end
