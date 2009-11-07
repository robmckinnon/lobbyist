require 'rss'

class AdminController < ApplicationController

  before_filter :require_user
  before_filter :require_admin_user, :only => [:shutdown]

  def index
  end

  def shutdown
    if request.post?
      if params[:commit] == 'Shutdown site'
        `rake apache:shutdown`
      end
    end
  end
end
