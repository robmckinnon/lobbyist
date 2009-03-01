class DataSourcesController < ApplicationController

  before_filter :find_data_source, :only => [:show, :edit]
  before_filter :ensure_current_data_source_url, :only => :show

  def index
    @data_sources = DataSource.all
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
      render :action => :new
    end
  end

  def update
    @data_source = DataSource.find(params[:id])

    if @data_source.update_attributes(params[:data_source])
      flash[:notice] = "Successfully updated #{@data_source.name}."
      redirect_to data_sources_path
    else
      render :action => 'edit'
    end
  end

  private

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
