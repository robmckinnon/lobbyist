class Member < ActiveRecord::Base
  
  belongs_to :person
  
  has_many :members_interests_entries

  validates_uniqueness_of :publicwhip_id, :allow_nil => true

  class << self
    def current_members
      today = Date.today.to_s
      find(:all, :conditions => '"'+today+'" < to_date', :include => :person)
    end

  end
  
  def current?
    Date.today < to_date    
  end
  
  def person_name
    person.name
  end
  
  
end
