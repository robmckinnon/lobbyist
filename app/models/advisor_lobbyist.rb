class AdvisorLobbyist < ActiveRecord::Base

  belongs_to :special_advisor
  belongs_to :consultancy_staff_member

end
