class MembersInterestsEntry < ActiveRecord::Base
  
  belongs_to :member
  belongs_to :data_source
  
  has_many :members_interests_items, :dependent => :destroy
  
  def person_name
    member.person_name
  end
end
