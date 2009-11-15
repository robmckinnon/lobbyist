class OrganisationGroup < ActiveRecord::Base

  has_friendly_id :name, :use_slug => true, :strip_diacritics => true

  has_many :organisation_group_members
  has_many :organisations, :through => :organisation_group_members
  belongs_to :sic_uk_class

  validates_presence_of :name

  def new_organisation_group_member_attributes=(member_attributes)
    member_attributes.each do |key, attributes|
      organisation_group_members.build(attributes)
    end
  end

  def existing_organisation_group_member_attributes=(member_attributes)
    organisation_group_members.reject(&:new_record?).each do |organisation_group_member|
      attributes = member_attributes[organisation_group_member.id.to_s]
      if attributes
        organisation_group_member.attributes = attributes
      else
        organisation_group_members.delete(organisation_group_member)
      end
    end
  end

end
