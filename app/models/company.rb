# class Slug < ActiveRecord::Base
  # def to_friendly_id
    # name
  # end
# end

class Company < ActiveRecord::Base

  has_friendly_id :name, :use_slug => true, :strip_diacritics => true

  validates_uniqueness_of :company_number

  has_many :company_classifications

  NUMBER_PATTERN = /([A-Z][A-Z])?(\d)?(\d)?\d\d\d\d\d\d/

  class << self

    def company_is_a_match? company, name
      upcase_name = name.upcase
      if upcase_name[/^(.+) (LIMITED|LTD)\.?$/]
        upcase_name = $1
      end
      company.name == upcase_name || company.name[/^(.+) (LIMITED|LTD)\.?$/,1] == upcase_name
    end

    def find_match name
      begin
        companies = retrieve_by_name name.gsub('&','and')
        puts ""
        puts "#{name}: #{companies.size} matches"

        if companies.size == 1
          if company_is_a_match?(companies.first, name)
            company = companies.first
            puts company.name
            return company
          end
        elsif companies.size > 1
          companies.each do |company|
            if company_is_a_match?(company, name)
              puts company.name
              return company
            end
          end
        end

        return nil
      rescue Exception => e
        puts "#{Exception.class.name} while populating company for '#{name.inspect}': #{e.to_s}"
      end
    end

    def find_all_by_slug(slug)
      Slug.find(:all, :conditions => {:name => slug}).collect(&:sluggable)
    end

    # raises CompaniesHouse::Exception if error
    def retrieve_by_name name
      term = name.squeeze(' ')
      term = "#{term} " if term.size < 4 && !term.ends_with?(' ')
      search = CompanySearch.find_by_term(term, :include => :companies)

      if search && search.term == term
        companies = search.companies
      elsif true
        company_numbers = retrieve_company_numbers_by_name_with_rows(term, 20)
        if company_numbers.empty?
          companies = []
        else
          search = CompanySearch.new :term => term
          companies = company_numbers.collect do |number|
            logger.info "retrieving #{number}"
            company = retrieve_by_number(number)
            search.company_search_results.build(:company_id => company.id) if company
            company
          end
          companies.compact!
          search.save unless companies.empty?
        end
      end

      companies
    end

    def numberfy text
      text = text.gsub('1','one').gsub('2','two').gsub('3','three').gsub('4','four').gsub('5','five').gsub('6','six').gsub('7','seven').gsub('8','eight').gsub('9','nine').gsub('0','o')
      if text[/^(.*) (group|limited|llp|ltd|plc)\.?$/i]
        text = $1
      end
      text
    end

    def retrieve_company_numbers_by_name_with_rows name, rows, company_numbers = [], last_name=name
      logger.info "retriving #{rows} for #{last_name}"
      results = CompaniesHouse.name_search(last_name, :search_rows => rows)

      no_space_name = numberfy(name.tr('- .',''))
      alt_name = numberfy(name).gsub(' ','[^A-Z]')

      if results && results.respond_to?(:co_search_items)
        items = results.co_search_items
        logger.info items.size

        if numberfy(items.last.company_name).tr('- .','')[/#{no_space_name}/i]
          sleep 0.5
          company_numbers = company_numbers + retrieve_company_numbers_by_name_with_rows(name, 100, company_numbers, items.last.company_name.gsub('&','AND'))
          logger.info "numbers #{company_numbers.size} for #{last_name}"
        else
          logger.info "no more matches: #{items.last.company_name}"
        end

        matches = items.select{|item| item.company_name[/#{name}/i] || numberfy(item.company_name)[/#{alt_name}/i]}
        company_numbers = (matches.collect(&:company_number) + company_numbers).uniq
      end
      company_numbers.compact.uniq
    end

    def retrieve_by_number number
      number = number.strip
      company = find_by_company_number(number)
      unless company
        details = CompaniesHouse.company_details(number) # doesn't work between 12am-7am, but number_search does
        sleep 0.5
        if details && details.respond_to?(:company_name)
          company_number = details.company_number.strip
          if number == company_number
            company = Company.create({:name => details.company_name,
                :company_number => company_number,
                :address => details.reg_address.address_lines.join("\n"),
                :company_status => details.company_status,
                :company_category => details.company_category,
                :incorporation_date => details.respond_to?(:incorporation_date) ? details.incorporation_date : nil,
                :country_code => 'uk'
            })
            if details.respond_to?(:sic_codes)
              if details.sic_codes.respond_to?(:sic_text)
                sic_text = details.sic_codes.sic_text
                if sic_text.is_a?(Array)
                  sic_text.each do |text|
                    CompanyClassification.create_from_company_and_sic_text company, text
                  end
                elsif sic_text.is_a?(String)
                  CompanyClassification.create_from_company_and_sic_text company, sic_text
                end
              end
            end
          end
        end
      end
      company
    end

    def name_search name
      results = CompaniesHouse.name_search(name)
      results
    end

    def find_all_by_company_name name
      find(:all, :conditions => ['name like ?', %Q|#{name.gsub('"','')}%|]) +
        find(:all, :conditions => ['name like ?', %Q|The #{name.gsub('"','')}%|])
    end

    def find_this identifier
      if identifier[Company::NUMBER_PATTERN]
        company = retrieve_by_number(identifier)
      else
        company = find(identifier)
      end
      company
    end
  end

  def companies_house_url
    @companies_house_url ||= (AltCompaniesHouse.url_for_number(company_number) || '')
  end

  def companies_house_data
    begin
      @companies_house_data ||= (AltCompaniesHouse.search_by_number(company_number) || '')
    rescue Timeout::Error
      # do nothing for the moment
    end
  end

  def find_company_data
    data = AltCompaniesHouse.search_by_name(name)
  end

  def to_more_xml(host='localhost')
    to_xml(:except=>[:id,:created_at,:updated_at]) do |xml|
      xml.ogc_supplier(ogc_suppliers.empty? ? 'no' : 'yes')
      xml.lobbyist_client(lobbyist_clients.empty? ? 'unknown' : 'yes')
      xml.id("http://#{host}/#{country_code}/#{company_number}")
      xml.long_url("http://#{host}/#{country_code}/#{company_number}/#{friendly_id}")
      xml.xml_url("http://#{host}/#{country_code}/#{company_number}.xml")
    end.gsub('ogc_supplier','ogc-supplier').gsub('lobbyist_client','lobbyist-client').gsub('short_id','short-id')
  end

end
