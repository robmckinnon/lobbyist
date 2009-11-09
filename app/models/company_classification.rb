class CompanyClassification < ActiveRecord::Base

  belongs_to :organisation
  belongs_to :sic_uk_class
  belongs_to :company

  # validates_presence_of :organisation
  validates_presence_of :company
  validates_presence_of :sic_uk_class

  class << self

    def create_from_company_and_sic_text company, text
      if text[/^(\d+)\s.+$/]
        number = $1.to_i
        sic_class = SicUkClass.find_by_sic_uk_code(number)
        if sic_class
          create :sic_uk_class_id => sic_class.id, :company_id => company.id,
            :sic_uk_class_code => number, :sic_uk_section_code => sic_class.sic_uk_section.code
        else
          warn "cannot find sic class for code: #{text} (#{company.inspect})"
          nil
        end
      else
        nil
      end
    end

    def find_section_and_organisations_and_lobbyists_and_people section_code, class_code=nil
      all = find(:all, :conditions => {:sic_uk_section_code => section_code}, :include => :organisation)

      if all.empty?
        return [SicUkSection.find_by_code(section_code), []]
      else
        organisations = all.collect(&:organisation).compact.sort_by(&:name)
        if class_code
          organisations = organisations.select{|o| o.company_classifications.collect(&:sic_uk_class_code).include?(class_code) }
        end
        lobbyists = organisations.collect(&:consultancy_clients).flatten.collect(&:lobbyist_firm_retained).uniq.sort_by(&:name)

        people = organisations.collect(&:members_interests_items).flatten.collect(&:person).uniq.sort_by(&:name)
        section = all.first.sic_uk_class.sic_uk_section
        return [section, organisations, lobbyists, people]
      end
    end
  end
end
