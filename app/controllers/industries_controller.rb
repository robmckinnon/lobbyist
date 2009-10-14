class IndustriesController < ApplicationController

  def index
    @sections = SicUkSection.find_all_by_year(2003)
    @organisations_by_section = {}

    @sections.each do |section|
      @organisations_by_section[section] = CompanyClassification.count(:conditions => {:sic_uk_section_code => section.code}) - CompanyClassification.count(:conditions => {:sic_uk_section_code => section.code, :organisation_id => nil})
    end
  end

  def show
    code = params[:sic_section_code]
    @section, @organisations = CompanyClassification.find_section_and_organisations code
  end
end
