class Person < ActiveRecord::Base

  has_friendly_id :name, :use_slug => true, :strip_diacritics => true

  has_many :consultancy_staff_members
  has_many :register_entries, :through => :consultancy_staff_members

  has_many :appointees
  has_many :former_roles, :through => :appointees
  has_many :appointments, :through => :appointees

  has_many :lords
  has_many :members

  validates_presence_of :name
  validates_uniqueness_of :publicwhip_id, :allow_nil => true

  class << self

    def all_lords
      lords = Lord.all
      people = lords.collect(&:person).compact.sort_by(&:name)
      details = lords.group_by(&:person)
      details.each {|k,v| details[k] = v.last}
      return [people, details]
    end

    def current_lords
      lords = Lord.current_lords
      people = lords.collect(&:person).compact.sort_by(&:name)
      details = lords.group_by(&:person)
      details.each {|k,v| details[k] = v.last}
      return [people, details]
    end

    def current_mps
      members = Member.current_members
      people = members.collect(&:person).compact.sort_by(&:name)
      details = members.group_by(&:person)
      details.each {|k,v| details[k] = v.last}
      return [people, details]
    end
  end

  def current_member
    members.size > 0 ? members.select(&:current?).first : nil
  end

  def current_roles
    if current = current_member
      current.current_offices
    else
      []
    end
  end

  def former_offices
    if current = current_member
      current.former_offices
    else
      []
    end
  end

  def interests_in_organisations(organisations)
    items = members.collect(&:members_interests_items).flatten
    items = items.select {|item| (item.interest_organisations & organisations).size >= 1}.group_by(&:description)
    items.keys.collect {|k| items[k].first}
  end
end
