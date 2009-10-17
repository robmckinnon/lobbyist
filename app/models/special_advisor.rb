class SpecialAdvisor < ActiveRecord::Base

  belongs_to :special_advisor_list
  belongs_to :special_advisor_appointing_minister

  has_friendly_id :name, :use_slug => true, :scope => :special_advisor_list

end
