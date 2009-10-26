class MemberOffice < ActiveRecord::Base

  belongs_to :member

  class << self

    def from_date_and_description date=Date.parse('2004-07-19'), description='Secretary of State for Work and Pensions'
      if description[/\sfor\s/]
        position, department = description.split(' for ')
        matches = find_all_by_position(position)
        matches = matches.select do |office|
          (office.to_date.nil? || (date <= office.to_date)) && (date >= office.from_date) && (office.department && office.department[/#{department}/])
        end
        if matches.size == 1
          matches.first
        elsif matches.size == 0
          logger.warn "no matches: #{date} #{description}"
          nil
        else
          logger.warn "too many matches: #{date} #{description}: #{matches.inspect}"
          nil
        end
      else
        nil
      end
    end

    def load_office office
      unless MemberOffice.exists?(:publicwhip_id => office.publicwhip_id)
        if member = Member.find_by_publicwhip_id(office.matchid)
          office = MemberOffice.create :name => office.name,
              :department => (office.dept.blank? ? nil : office.dept),
              :position => (office.position.blank? ? nil : office.position),
              :publicwhip_id => office.publicwhip_id,
              :publicwhip_member_id => office.matchid,
              :member_id => member.id,
              :from_date => (office.fromdate.blank? ? nil : office.fromdate),
              :to_date => (office.todate.blank? ? nil : office.todate),
              :source => office.source
          puts "created: #{office.inspect}"
        else
          warn "member not found for: #{office.inspect}"
        end
      end
    end

    def office_groups
      xml = open('data/members/ministers.xml').read
      xml.gsub!(' id=',' publicwhip_id=')
      hash = Hash.from_xml xml
      offices = Morph.from_hash hash
      offices.ministerofficegroups
    end

    def load_offices
      office_groups.each do |group|
        group.moffices.each do |office|
          load_office office
        end if group.moffices

        load_office group.moffice if group.moffice
      end
    end
  end

  def position_and_department
    if position && department
      "#{position} - #{department}"
    elsif position
      position
    elsif department
      department
    end
  end

  def current?
    if to_date
      Date.today < to_date
    else
      true
    end
  end

  def former?
    !current?
  end
end
