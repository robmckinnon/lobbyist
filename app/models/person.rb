class Person < ActiveRecord::Base

  has_friendly_id :name, :use_slug => true, :strip_diacritics => true

  has_many :consultancy_staff_members
  has_many :register_entries, :through => :consultancy_staff_members

  has_many :appointees
  has_many :former_roles, :through => :appointees
  has_many :appointments, :through => :appointees

  has_many :members

  validates_presence_of :name
  validates_uniqueness_of :publicwhip_id, :allow_nil => true

  class << self
    
    def current_mps
      members = Member.current_members
      people = members.collect(&:person).sort_by(&:name)
      details = members.group_by(&:person)
      details.each {|k,v| details[k] = v.last}
      return [people, details]
    end
  end
  
  def current_member
    members.size > 0 ? members.select(&:current?).first : nil
  end
end
