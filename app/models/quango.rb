class Quango < ActiveRecord::Base

  belongs_to :government_department
  belongs_to :organisation

  validates_uniqueness_of :name
  validates_uniqueness_of :organisation_id

  class << self
    def create_if_new data
      name, name_in_brackets, acronym, dormant = break_name(data[:name])
      
      unless exists?(:name => name)
        puts "quango: " + name.to_s
        url = data[:url]  
        if url && !url[/^http:\/\//]
          url = "http://#{url}"
        end

        if url.nil? || name[/(Health and Saftey Commission)|(Pension Protection Fund Ombudsman)|(Pesticides Saftey Directorate)|(Copyright Tribunal)|(Accounts Commission for Scotland)|(Sustainable Development Commission in Scotland)|(Defence Aviation Repair Agency)|(Valuation Tribunals)|(National Heritage Memorial Fund)/] || url[/(See Defra's Non-Executive Bodies List)|(There is no available data)|(n\/a)/i] || url == "http://www.mod.uk/NR/rdonlyres/4C8D6BF8-0805-4F46-9A63-8CFC40660008/0/MOD_non_departmental_publicbodies.pdf"
          url = ''
        end
        organisation = Organisation.find_or_create_from_url_and_name(url, name)
        if !url.blank? && !organisation.url
          organisation.url = url
          organisation.save!
        end
        puts "organisation: " + organisation.name.to_s

        dept = GovernmentDepartment.find_or_create_by_name(data[:department])

        quango = create!({:name => name,
            :acronym => acronym,
            :dormant => dormant,
            :name_in_brackets => name_in_brackets,
            :alternate_name => data[:alternate_name],
            :quango_type => data[:quango_type],
            :focus => data[:focus],
            :url => url,
            :source => data[:source],
            :organisation_id => organisation.id,
            :government_department_id => dept.id
        })
      end
    end
    
    private
    def break_name name, dormant=false
      if name[/^(.+) \(([A-Z]+)\)$/]
        return [$1, nil, $2, dormant]
      elsif name[/^(.+) \(([^\)]+)\)$/]
        remaining = $1
        in_brackets = $2
        if in_brackets == 'Wales'
          return [name, nil, nil, dormant]
        elsif in_brackets[/dormant/i]
          return break_name(remaining, true)
        else
          return [remaining, in_brackets, nil, dormant]
        end
      else
        return [name, nil, nil, dormant]
      end
    end
  end

end
