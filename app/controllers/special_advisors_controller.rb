class SpecialAdvisorsController < ApplicationController

  before_filter :find_special_advisor_list, :only => [:show_advisor, :show]

  def index
    @lists = SpecialAdvisorList.all.sort_by(&:at_date).reverse
  end

  def show
    advisors = @advisor_list.special_advisors
    @advisors_by_minister = advisors.group_by(&:special_advisor_appointing_minister)
    @appointing_ministers = @advisors_by_minister.keys
  end

  def show_advisor
    person_id = params[:person_id]
    @advisor = @advisor_list.special_advisors.detect{|x| x.friendly_id == person_id }
    @consultancy_staff_members = @advisor.consultancy_staff_members
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
