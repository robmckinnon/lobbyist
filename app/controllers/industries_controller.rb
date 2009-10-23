class IndustriesController < ApplicationController

  def index
    @sections = SicUkSection.find_all_by_year(2003)
    @organisations_by_section = {}
    @organisations_by_sic_class = Hash.new {|h,k| h[k] = {} }

    @sections.each do |section|
      @organisations_by_section[section] = CompanyClassification.count(:conditions => {:sic_uk_section_code => section.code}) - CompanyClassification.count(:conditions => {:sic_uk_section_code => section.code, :organisation_id => nil})
      section.sic_uk_classes.each do |sic_class|
        @organisations_by_sic_class[section][sic_class] = CompanyClassification.count(:conditions => {:sic_uk_class_id => sic_class.id}) - CompanyClassification.count(:conditions => {:sic_uk_class_id => sic_class.id, :organisation_id => nil})
      end
    end
  end

  def show
    code = params[:sic_section_code]
    @section, @organisations, @lobbyists = CompanyClassification.find_section_and_organisations_and_lobbyists code
    @show_classifications = @organisations.collect(&:company_classifications).flatten.compact.uniq.size > 1
  end

  def show_class
    section_code = params[:sic_section_code]
    class_code = params[:sic_class_code].to_i
    @section, @organisations, @lobbyists = CompanyClassification.find_section_and_organisations_and_lobbyists section_code, class_code
    @title = @organisations.first.company_classifications.first.sic_uk_class.description
    render :template => 'industries/show'
  end

end
