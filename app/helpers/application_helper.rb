# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def link_to_consultant name, entry
    organisation_id = entry.organisation.friendly_id
    person_id = entry.consultancy_staff_members.detect{|x| x.name == name}.friendly_id

    link_to h(name), show_staff_member_url(:id => organisation_id, :person_id => person_id)
  end
end
