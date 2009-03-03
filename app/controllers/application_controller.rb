# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  def render_not_found message='Page not found.'
    render :text => message, :status => :not_found
  end

  def store_location
    session[:return_to] = request.request_uri
    session[:second_return_to] = nil
  end

  def redirect_back_or_default(default)
    return_to = session[:return_to]
    session[:return_to] = session[:second_return_to] || nil
    session[:second_return_to] = nil
    redirect_to(return_to || default)
  end

  protected

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
      @organisations_list = @organisations.collect{|o| [o.name, o.id]}
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
