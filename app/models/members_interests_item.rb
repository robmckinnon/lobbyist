class MembersInterestsItem < ActiveRecord::Base
  
  def text= text
    self.registered_date_text = text[/(\(Registered ([^\)]+)\))/]
    
    if registered_date_text
      self.registered_date = Date.parse($1)
      text = text.sub(registered_date_text, '') 
    end
    
    if received = text[/would receive some &pound;(\S+) /]
      self.currency_symbol = "£"
      self.from_amount_text = received.strip
      self.from_amount = number $1
    end
    
    if received = text[/receive a retaining annual fee of &pound;(\S+) /]
      self.currency_symbol = "£"
      self.actual_amount_text = received.strip
      self.actual_amount = number $1
    end
    
    text.scan(/(\(([^\)]+)\))/) do |string|
      string = string.first if string.is_a?(Array)
      self.currency_symbol = "£" if string[/&pound;/]
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
        when /Up/i
          self.up_to_amount_text = string
          self.up_to_amount = number parts.last
      end
    end
    self.description = text.strip
  end
  
  private
  
  def number text
    text.sub('(','').sub('&pound;','').tr(',','').chomp('.').chomp(')').to_i
  end
  
end
