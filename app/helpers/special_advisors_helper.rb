module SpecialAdvisorsHelper

  def show_lobbyist lobbyist
    lobbyist.consultancy_staff_member.name +
      ' <br/><span style="color: grey">' +
      lobbyist.special_advisor.special_advisor_list.at_date.to_s + ' ' +
      lobbyist.special_advisor.special_advisor_appointing_minister.title +
      (lobbyist.special_advisor.member_office ? " #{link_to lobbyist.special_advisor.member_office.name, person_path(lobbyist.special_advisor.member_office.member.person) }" : '') +
      '</span> <br/><span style="color: grey">' +
      lobbyist.consultancy_staff_member.consultancy +
      '</span>'
  end
end
