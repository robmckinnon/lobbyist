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
  end
  
  def to_tsv
    max = [from_amount, up_to_amount, actual_amount].compact.max
    "#{person_name}\t#{registered_date ? registered_date.to_s(:dd_mmm_year) : ''}\t#{category_number}\t#{category_name}\t#{subcategory}\t#{max}\t#{from_amount}\t#{actual_amount}\t#{up_to_amount}\t#{description}"
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
    companies.each do |name|
      organisation = Organisation.find_or_create_by_name name
      unless MembersOrganisationInterest.exists?(:organisation_id => organisation.id, :members_interests_item_id => self.id)
        puts name
        MembersOrganisationInterest.create! :organisation_id => organisation.id, :members_interests_item_id => self.id
      end
    end
  end

  def companies
    indicators = %w[limited ltd plc group incorporated inc]
    indicator_group = "( #{indicators.join('| ')})"
    regexp = Regexp.new(indicator_group, Regexp::IGNORECASE)
    text = indicators.inject(description) {|text, i| text.gsub!(" #{i}", " #{i.capitalize}"); text}
    nouns = MembersInterestsItem.proper_nouns text

    nouns.flatten.uniq.sort.select {|x| x[regexp]}.select{|x| !x[/,/]}
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
