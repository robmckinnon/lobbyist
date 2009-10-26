class Member < ActiveRecord::Base

  belongs_to :person

  has_many :member_offices

  has_many :members_interests_entries
  has_many :members_interests_items, :through => :members_interests_entries

  validates_uniqueness_of :publicwhip_id, :allow_nil => true

  class << self
    def clean_name name
      name = name.sub('The Rt Hon ','')
      name.sub!('Rt Hon ','')
      name.sub!('Hon ','')
      name.sub!('Dr ','')
      name.sub!(' MP','')
      name.sub!(' QC','')
      name.sub!('The ','')
      name.sub!(' CBE', '')
      name
    end

    def current_members
      today = Date.today.to_s
      find(:all, :conditions => '"'+today+'" < to_date', :include => :person)
    end

    def from_name name
      name = clean_name name
      parts = name.split
      first = parts.first
      last = parts.last.sub('Grifﬁths','Griffiths')
      members = Member.find_all_by_firstname_and_lastname(first, last)

      people = members.collect(&:person).compact.uniq
      if people.size == 1
        member = members.first
        print first + ' ' + last + ': ' if !member
        person = people.first
        person
      elsif people.size > 1
        raise "more than one match: " + people.inspect
      else
        nil
      end
    end
  end

  def current?
    Date.today < to_date
  end

  def former?
    !current?
  end

  def person_name
    person.name
  end

  def current_offices
    member_offices.select(&:current?)
  end

  def former_offices
    member_offices.select(&:former?).sort_by(&:to_date)
  end
end
