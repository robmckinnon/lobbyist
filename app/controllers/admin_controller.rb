require 'rss'

class AdminController < ApplicationController

  before_filter :require_user, :only => [:index, :edit, :new, :create, :update, :delete]

  def index
    @recommended_merges = Organisation.recommended_limited_merges
  end

end
