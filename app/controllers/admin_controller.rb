require 'rss'

class AdminController < ApplicationController

  before_filter :require_user, :only => [:index, :edit, :new, :create, :update, :delete]

  def index
    @current_user = current_user
  end

end
