class ConsultancyStaffMember < ActiveRecord::Base

  belongs_to :person
  belongs_to :register_entry
  has_one :organisation, :through => :register_entry

  has_many :advisor_lobbyists, :dependent => :destroy

  validates_presence_of :name
  has_friendly_id :name, :use_slug => true, :scope => :register_entry

  class << self

    def dupes
      c = ConsultancyStaffMember.all.group_by(&:name)
      c.each {|k,v| c[k] = v.group_by(&:organisation) }
      z = c.to_a.select{|x| x[1].keys.size > 1}
      z
    end

    def set_friendly_ids
      find_each do |member|
        if member.name.include?("‐")
          member.name = name.sub("‐",'-')
        end
        puts member.name
        member.save!
      end
    end

  end

  def consultancy
    register_entry.organisation_name
  end

  def dates
    [register_entry.data_source.period_start, register_entry.data_source.period_end]
  end
end
