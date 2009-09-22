require 'zlib'
require 'stringio'

class ApplicationController < ActionController::Base

  caches_action :home

  before_filter :authenticate, :except => [:home]
  after_filter :compress

  auto_complete_for :person, :name
  auto_complete_for :organisation, :name

  helper :all # include all helpers, all the time
  # protect_from_forgery # See ActionController::RequestForgeryProtection for details

  filter_parameter_logging :password

  def home
    render :template => 'application/home', :layout => false
  end

  def search
    if request.post?
      if params['person']
        name = params['person']['name']
        person = Person.find_by_name(name)
        if person
          redirect_to person_path(person)
        else
          flash['person_not_found'] = "#{name} not found"
        end
      elsif params['organisation']
        name = params['organisation']['name']
        organisation = Organisation.find_by_name(name)
        if organisation
          redirect_to organisation_path(organisation)
        else
          flash['organisation_not_found'] = "#{name} not found"
        end
      end
    else
      render :template => 'application/search'
    end
  end

  def authenticate
    auth = YAML.load_file(RAILS_ROOT+'/config/auth.yml')
    auth.symbolize_keys!
    authenticate_or_request_with_http_basic do |id, password|
      id == auth[:user] && password == auth[:password]
    end
  end

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

    def compress
      accepts = request.env['HTTP_ACCEPT_ENCODING' ]
      if accepts && accepts =~ /(x-gzip|gzip)/
        encoding = $1
        output = StringIO.new
        def output.close # Zlib does a close. Bad Zlib...
          rewind
        end
        gz = Zlib::GzipWriter.new(output)
        gz.write(response.body)
        gz.close
        if output.length < response.body.length
          response.body = output.string
          response.headers['Content-encoding' ] = encoding
        end
      end
    end

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
      appc = Organisation.find_by_alternate_name('APPC')
      acoba = Organisation.find_by_alternate_name('ACOBA')
      @organisations.delete(appc)
      @organisations.delete(acoba)
      @organisations.insert(0,appc)
      @organisations.insert(0,acoba)
      @organisations.compact!
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
