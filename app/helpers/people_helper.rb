module PeopleHelper

  def add_appointee_link(name)
    link_to_function name do |page|
      page.insert_html :bottom, :appointees, :partial => 'appointee' , :object => Appointee.new
    end
  end

  def show_interest item
    organisations = item.organisations
    text = item.description
    organisations.each do |company|
      organisation = Organisation.find_by_name(company)
      if organisation
        text = text.sub(company, link_to(company, organisation_path(organisation) ) )
      end
    end
    text + " (#{item.paying_organisation})"
  end

  def date_to_s date
    date.to_s(:dd_mmm_year).reverse.chomp('0').reverse
  end

  def constituency_summary person
    members = person.members
    members = members.group_by {|m| "#{m.party} MP for #{m.constituency}"}
    summary = []
    members.each do |constituency, members|
      prefix = members.select(&:current?).empty? ? 'Former ' : ''
      dates = members.collect{|m| "#{date_to_s(m.from_date)}#{m.current? ? '-' : '-' + date_to_s(m.to_date)}" }.join(', ')
      summary << "#{prefix}#{constituency} (#{dates})"
    end
    summary.join("<br />")
  end
end
