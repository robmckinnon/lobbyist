class SpecialAdvisorList < ActiveRecord::Base

  validates_uniqueness_of :at_date
  has_many :special_advisors, :dependent => :destroy
  has_many :special_advisor_appointing_ministers, :through => :special_advisors

  class << self
    def load_file file
      doc = Hpricot open(file)
      headings = (doc/'h4')
      heading = headings.find {|h| h.inner_text.strip[/Special Advisers/]}
      heading.next_sibling.inner_text[/post at (\d+\s\S+\s+\d\d\d\d)/]
      date = Date.parse($1)
      puts date
      advisor_list = find_or_create_by_at_date(date)
      find_depts(heading).each do |dept|
        load_dept dept, advisor_list
      end
    end

    def find_depts heading
      table = heading.next_sibling
      while (table.name != 'table')
        table = table.next_sibling
      end
      depts = (table/'tr/td[1]')
    end

    def load_dept dept, advisor_list
      dept_name = dept.inner_text.strip.chomp('1').chomp('2').chomp('3')

      unless dept_name[/Appointing Minister/i] || dept_name[/\(1\)/]
        minister = SpecialAdvisorAppointingMinister.find_or_create_by_title(dept_name)

        list = dept.next_sibling
        spads = (list/'p').collect do |item|
          value = item.inner_text
          value.split('/')
        end.flatten

        names = spads.collect {|s| s.split('(').first.strip }
        qualifications = spads.collect {|s| x = s.split('(') ; x.size == 2 ? x.last.strip.chomp(')') : nil }

        names.each_with_index do |name, index|
          qualification = qualifications[index]
          attributes = {:name => name, :qualification => qualification,
              :special_advisor_appointing_minister_id => minister.id}
          unless SpecialAdvisor.exists?(attributes.merge(:special_advisor_list_id => advisor_list.id))
            advisor_list.special_advisors.create attributes
          end
        end
        y advisor_list.special_advisors
      end
    end
  end

end
