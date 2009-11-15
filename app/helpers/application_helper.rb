# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def link_to_consultant name, entry
    organisation_id = entry.organisation.friendly_id
    person_id = entry.consultancy_staff_members.detect{|x| x.name == name}.friendly_id

    link_to h(name), show_staff_member_url(:id => organisation_id, :person_id => person_id)
  end

  def show_interest item
    organisations = item.organisations
    text = item.description

    # raise item.paying_organisation
    unless item.paying_organisation.blank?
      if text[/(paid for|paid|funded|met|provided) by (the )?(#{item.paying_organisation})/]
        text.sub!(/((paid for|paid|funded|met|provided) by (the )?)(#{item.paying_organisation})/, '\1' + "<a href=''>#{item.paying_organisation}</a>")
      else
        organisation = Organisation.find_by_name(item.paying_organisation)
        if organisation
          text.sub!(/#{item.paying_organisation}/i, link_to(item.paying_organisation, organisation_path(organisation) ) )
        else
          # text.sub!(item.paying_organisation, "<a href=''>#{item.paying_organisation}</a>")
        end
      end
    else
      organisations.each do |company|
        organisation = Organisation.find_by_name(company)
        if organisation
          text.sub!(company, link_to(company, organisation_path(organisation) ) )
        end
      end
    end

    text
  end
end
