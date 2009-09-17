require 'acts_as_proper_noun_identifier'

class MembersInterestsItem < ActiveRecord::Base

  include Acts::ProperNounIdentifier

  belongs_to :members_interests_entry
  belongs_to :members_interests_category

  has_many :members_organisation_interests, :dependent => :delete_all
  has_many :organisations, :through => :members_organisation_interests

  after_save :set_members_organisation_interests

  class << self
    def overlap
      all.collect(&:organisations).flatten.compact.uniq.select{|x| !x.register_entries.empty?}
    end

    def write_to_tsv
      tsv = []
      all = find(:all, :include => {:members_interests_entry => {:member => :person} })
      all.each {|i| tsv << i.to_tsv}
      tsv = tsv.join("\n")
      File.open(RAILS_ROOT+'/interest.tsv', 'w') {|f| f.write tsv }
    end
  end

  def to_tsv
    "#{person_name}\t#{max_amount}\t#{paying_organisation}\t#{description}\t#{from_amount}\t#{actual_amount}\t#{up_to_amount}\t#{members_party}\t#{registered_date ? registered_date.to_s(:dd_mmm_year) : ''}\t#{category_number}\t#{category_name}\t#{subcategory}"
  end

  def max_amount
    [from_amount, up_to_amount, actual_amount].compact.max
  end

  def members_party
    members_interests_entry.member.party
  end

  def category_number
    members_interests_category.number
  end

  def category_name
    members_interests_category.name
  end

  def person
    members_interests_entry.person
  end

  def person_name
    members_interests_entry.person_name
  end

  def set_members_organisation_interests
    puts members_interests_entry.member.person.name
    organisations.each do |name|
      organisation = Organisation.find_or_create_by_name name
      unless MembersOrganisationInterest.exists?(:organisation_id => organisation.id, :members_interests_item_id => self.id)
        puts name
        MembersOrganisationInterest.create! :organisation_id => organisation.id, :members_interests_item_id => self.id
      end
    end
  end

  def proper_nouns indicators=%w[limited ltd plc group incorporated inc llp society]
    text = indicators.inject(description.sub('Parliamentary adviser ','')) {|text, i| text.gsub!(" #{i}", " #{i.capitalize}"); text}
    text.sub!('Co. (UK) Ltd', 'Co (UK) Ltd')
    text.sub!('a Group','a group')
    text.sub!('Income','income')
    text.sub!("Lloyd's",'Lloyds')
    text.sub!("ITV1's",'ITV1 s')
    text.sub!('Helsingborg','')
    text.sub!('Christian charity, CARE','CARE')
    text.sub!('Conference Dinner','')
    text.sub!('Annual Awards Dinner','')
    text.sub!('Annual Management Dinner','')
    text.sub!('Surveyors Dinner','Surveyors')
    text.sub!('CARE (Christian Action, Research and Education)','CARE')
    text.sub!('CARE (Christian Action Research and Education)', 'CARE')
    text.sub!('Christian Action, Research and Education (CARE)','CARE')
    text.sub!('Gordon Poole Agency for ','')
    text.sub!('Forum for the ','Forumforthe ')
    text.sub!('Institute of Directors','InstituteofDirectors')
    text.sub!('Parliamentary Advisory Committee','ParliamentaryAdvisoryCommittee')
    text.sub!('Management consultant','')
    text.sub!(/^(Reception|Amount|Ongoing|Support|Practising|Stewardship|Weekly|Categories|Article|Printing|Programmes|Date|Provision|)\s/,'')
    text.sub!('Broadcasting fees','broadcasting fees')

    ignore = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday]
    ignore += %w[Up Currently Christianity Editor Article Articles Columnist
        Advisory Committee Board Senior Adviser Consultant Contributor Chair
        Auditorium Speaking Lecturer Lectures Author Member Solicitor Barrister
        Contract Remuneration Fee Fees Payment Non-practising Resigned Presenter
        Donations Surgeon Commander Secretary
        Deputy Managing Director Chairman Director Directors Registered]
    text.sub!('Sunday Times', 'SundayTimes')
    nouns = MembersInterestsItem.proper_nouns(text, :ignore => ignore, :ignore_in_quotes=>true, :ignore_dates => true)
    nouns = nouns.flatten.sort
    nouns.map{|x| x.chomp(',').chomp('.').chomp(':').chomp(')').
      sub('Forumforthe ','Forum for the ').
      sub('InstituteofDirectors','Institute of Directors').
      sub('ParliamentaryAdvisoryCommittee','Parliamentary Advisory Committee') }
  end

  def paying_organisation
    likely_org = nil
    if description[/(paid for|paid|met|funded|provided) by/]
      proper_nouns.each do |org|
        if description[/(paid for|paid|funded|met|provided) by (the )?(#{org})/]
          likely_org = org
        end
      end
    end

    if likely_org
      # raise likely_org
      if likely_org && likely_org[/^(Mr|Mrs|Miss) /]
        ''
      else
        likely_org
      end
    else
      orgs = organisations
      if orgs.empty? && category_name != 'Land and Property' # && max_amount
        if description[/(personal donation|Address of donor)/i]
          ''
        else
          orgs = proper_nouns
          if orgs.include?('Mail on Sunday')
            likely_org = 'Mail on Sunday'
          elsif orgs.include?('SundayTimes')
            likely_org = 'Sunday Times'
          else
            ['British Overseas Territory of Gibraltar',
            'United Arab Emirates', "Gibraltar's National Day",
            'The One Show','Daily Cooks Challenge','Research Assistant'
            ].each {|x| orgs.delete(x)}
            likely_org = orgs.max {|a,b| a.length <=> b.length } unless likely_org
          end
          if likely_org && likely_org[/^(Mr|Mrs|Miss) /]
            ''
          elsif likely_org
            likely_org
          else
            ''
          end
        end
      else
        orgs.max {|a,b| a.length <=> b.length }
      end
    end
  end

  def organisations
    indicators = %w[limited ltd plc group incorporated inc llp society lp]
    indicator_group = "( #{indicators.join('| ')})"
    regexp = Regexp.new(indicator_group, Regexp::IGNORECASE)

    orgs = proper_nouns indicators
    orgs = orgs.select {|x| x[regexp]}
    orgs = orgs.select{|x| !x[/,/]}.select{|x| !x[/No Income/i] }
    orgs
  end

  def text= text
    self.registered_date_text = text[/(\(Registered ([^\)]+)\))/]

    if registered_date_text
      self.registered_date = Date.parse($1)
      text = text.sub(registered_date_text, '')
    end

    if received = text[/would receive some (£|&pound;)(\S+) /]
      self.from_amount_text = received.strip
      self.from_amount = number $2
      self.currency_symbol = "£"
    end

    if received = text[/receive a retaining annual fee of (£|&pound;)(\S+) /]
      self.actual_amount_text = received.strip
      self.actual_amount = number $2
      self.currency_symbol = "£"
    end

    text.scan(/(\(([^\)]+)\))/) do |string|
      string = string.first if string.is_a?(Array)
      self.currency_symbol = "£" if string[/(£|&pound;)/]
      parts = string.split
      case parts[0]
        when /\d?\d \w+ \d\d\d\d/
          # ignore
        when /\d+-.*\d+/
          self.range_amount_text = string
          bits = string.split('-')
          self.from_amount = number bits.first
          self.up_to_amount = number bits.last
        when /Actual/i
          self.actual_amount_text = string
          self.actual_amount = number parts[1]
        when /(Up|maximum)/i
          self.up_to_amount_text = string
          self.up_to_amount = number parts.last
      end
    end
    self.description = text.strip
  end

  private

  def number text
    text.sub('(','').sub('&pound;','').tr(',','').chomp('.').chomp(')').sub("£",'').to_i
  end

end
