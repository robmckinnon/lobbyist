class SpecialAdvisor < ActiveRecord::Base

  belongs_to :special_advisor_list
  belongs_to :special_advisor_appointing_minister

  has_friendly_id :name, :use_slug => true, :scope => :special_advisor_list

  has_many :advisor_lobbyists, :dependent => :destroy

  class << self
    def match_with_lobbyists
      lobbyists = ConsultancyStaffMember.all.group_by(&:name)
      advisors = all

      advisors.each do |advisor|
        if matches = lobbyists[advisor.name]
          matches.each do |lobbyist|
            attributes = { :special_advisor_id => advisor.id, :consultancy_staff_member_id => lobbyist.id }
            unless AdvisorLobbyist.exists?(attributes)
              AdvisorLobbyist.create attributes
              puts "creating: #{advisor.name} - #{lobbyist.name}"
            end
          end
        end
      end
    end
  end

  def consultancy_staff_members
    advisor_lobbyists.collect(&:consultancy_staff_member)
  end

  def member_office
    MemberOffice.from_date_and_description special_advisor_list.at_date, special_advisor_appointing_minister.title
  end
end
