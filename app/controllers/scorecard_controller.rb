class ScorecardController < ActionController::Base

  caches_page :show

  def show
    if params[:date] == '2010-09-12'
      render 'scorecard/2010_09_12', :layout => false
    elsif params[:date].nil?
      render 'scorecard/show'
    else
      render_not_found
    end
  end

end
