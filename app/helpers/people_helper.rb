module PeopleHelper

  def add_appointee_link(name)
    link_to_function name do |page|
      page.insert_html :bottom, :appointees, :partial => 'appointee' , :object => Appointee.new
    end
  end

  def date_to_s date
    date.to_s(:dd_mmm_year).reverse.chomp('0').reverse
  end

  def date_range x
    "#{date_to_s(x.from_date)}#{x.current? ? ' - present' : ' - ' + date_to_s(x.to_date)}"
  end

  def constituency_summary person
    members = person.members
    members = members.group_by {|m| "#{m.party} MP for #{m.constituency}"}.to_a
    summary = []
    members = members.sort_by{|x| x[1].collect(&:from_date).compact.max }.reverse
    members.each do |constituency, members|
      dates = members.sort_by(&:from_date).reverse.collect{|m| "#{date_range(m)}" }.join(', ')

      if members.select(&:current?).empty?
        summary << "<span class='former_constituency'>Former #{constituency}<br/><span class='constituency_dates'>#{dates}</span>"
      else
        summary << "#{constituency}<br/><span class='constituency_dates'>#{dates}</span>"
      end
    end
    summary.join("<br />")
  end

  def add_roles roles, summary
    roles = roles.sort_by{|x| x.from_date }.reverse
    roles.each do |role|
      summary << role.position_and_department
      summary << "<span class='constituency_dates'>#{date_range(role)}</span>"
    end
  end

  def roles_summary person
    summary = []
    add_roles person.current_roles, summary
    add_roles person.former_offices, summary
    summary.join("<br />")
  end
end
