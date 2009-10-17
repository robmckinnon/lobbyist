class SpecialAdvisorsController < ApplicationController

  before_filter :find_special_advisor_list, :only => [:show_advisor, :show]

  def index
    @lists = SpecialAdvisorList.all.sort_by(&:at_date)
  end

  def show
    @appointing_ministers = @advisor_list.special_advisors.group_by(&:special_advisor_appointing_minister).keys
  end

  def show_advisor
    person_id = params[:person_id]
    @advisor = @advisor_list.special_advisors.detect{|x| x.friendly_id == person_id }
  end

  private

    def find_special_advisor_list
      begin
        @at_date = params[:date]
        @advisor_list = SpecialAdvisorList.find_by_at_date(@at_date)
        render_not_found unless @advisor_list
      rescue
        render_not_found
      end
    end

end
