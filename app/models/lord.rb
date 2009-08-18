class Lord < ActiveRecord::Base

  belongs_to :person

  class << self
    def from_name name
      name = Member.clean_name name
      parts = name.split
      first = parts.first
      last = parts[1]
      lords = Lord.find_all_by_title_and_lord_name(first, last)
      if lords.empty?
        lords = Lord.find_all_by_title_and_lord_of_name(first, last)
      end
      people = lords.collect(&:person).compact.uniq
      if people.size == 1
        lord = lords.first
        print first + ' ' + last + ': ' if !lord
        people.first
      elsif people.size > 1
        matching = people.select {|x| x.name == name}
        if matching.size == 1
          matching.first
        else
          logger.warn "more than one match for #{name}: #{people.inspect}"
          nil
        end
      else
        nil
      end
    end
  end
end
