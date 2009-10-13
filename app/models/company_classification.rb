class CompanyClassification < ActiveRecord::Base

  belongs_to :organisation
  belongs_to :sic_uk_class

  validates_presence_of :organisation
  validates_presence_of :sic_uk_class

  class << self

    def find_section_and_organisations section_code
      all = find(:all, :conditions => {:sic_uk_section_code => section_code}, :include => :organisation)

      if all.empty?
        return [SicUkSection.find_by_code(section_code), []]
      else
        organisations = all.collect(&:organisation)
        section = all.first.sic_uk_class.sic_uk_section
        return [section, organisations]
      end
    end
  end
end
