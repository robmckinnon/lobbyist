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
  end

  def redirect_back_or_default(default)
    return_to = session[:return_to]
    session[:return_to] = session[:second_return_to] || nil
    session[:second_return_to] = nil
    redirect_to(return_to || default)
  end
end
