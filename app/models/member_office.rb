class MemberOffice < ActiveRecord::Base

  belongs_to :member

  class << self

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
end
