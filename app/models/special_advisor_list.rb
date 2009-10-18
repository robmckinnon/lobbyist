class SpecialAdvisorList < ActiveRecord::Base

  validates_uniqueness_of :at_date
  has_many :special_advisors, :dependent => :destroy
  has_many :special_advisor_appointing_ministers, :through => :special_advisors

  class << self
    def normalize text
      text.strip.gsub("\n",' ').gsub('\s',' ').squeeze(' ')
    end

    def get_heading doc, h
      headings = (doc/h)
      heading = headings.find {|h| normalize(h.inner_text)[/Special Advisers/]}
    end

    def load_file file, ignore_third_column=false
      @ignore_third_column = ignore_third_column
      doc = Hpricot open(file)
      heading = get_heading(doc, 'h4')
      if heading.nil? || heading.empty?
        heading = get_heading(doc, 'h3')
      end

      heading.next_sibling.inner_text[/post at (\d+\s\S+\s+\d\d\d\d)/]

      date = Date.parse($1)
      puts date
      advisor_list = find_or_create_by_at_date(date)

      last_minister = nil
      find_depts(heading).each do |dept|
        minister_name = get_minister_name(dept, last_minister)
        unless minister_name[/Appointing Minister/i] || minister_name[/\(1/] || minister_name[/Advisers/i]
          load_dept dept, minister_name, advisor_list
          last_minister = minister_name
        end
      end
    end

    def get_minister_name dept, last_minister
      minister = dept.inner_text.strip.chomp('1').chomp('2').chomp('3').chomp('(2)').strip.chomp(',').chomp('(1)').chomp('3, 4','').strip
      name = normalize(minister)
      name.blank? ? last_minister : name
    end

    def find_depts heading
      table = heading.next_sibling
      while (table.name != 'table')
        table = table.next_sibling
      end
      depts = (table/'tr/td[1]')
    end

    def each_spad dept
      advisors = dept.next_sibling
      return if advisors.nil?
      texts = (advisors/'p')
      texts = [advisors] if texts.empty?
      texts.collect do |item|
        value = item.inner_text.sub('(p/t)','(pt)')
        values = value.split('/')
        values.each do |v|
          parts = v.split('(')
          name = parts.first.strip
          qualification = parts.size == 2 ? parts.last.strip.chomp(')') : nil
          if !@ignore_third_column && advisors.next_sibling && advisors.next_sibling.name == 'td'
            texts = (advisors.next_sibling/'p')
            texts = [advisors.next_sibling] if texts.empty?
            texts.each do |q|
              text = normalize(q.inner_text)
              qualification = text unless text.blank?
            end
          end
          yield name, qualification
        end
      end
    end

    def load_dept dept, minister, advisor_list
      minister = SpecialAdvisorAppointingMinister.find_or_create_by_title(minister)

      each_spad(dept) do |name, qualification|
        unless name[/Policy|Strategic|Events|Research/]
          attributes = {:name => name, :qualification => qualification,
              :special_advisor_appointing_minister_id => minister.id}
          advisor_attributes = attributes.merge(:special_advisor_list_id => advisor_list.id)

          unless SpecialAdvisor.exists?(advisor_attributes)
            advisor_list.special_advisors.create attributes
          end
        end
      end
      y advisor_list.special_advisors
      $stdout.flush
    end
  end

end
