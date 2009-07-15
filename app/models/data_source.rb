class DataSource < ActiveRecord::Base

  has_friendly_id :name, :use_slug => true, :strip_diacritics => true

  belongs_to :organisation

  has_many :appointees
  has_many :register_entries

  validates_presence_of :organisation
  validates_presence_of :name
  validates_uniqueness_of :name

  validates_presence_of :period_start, :unless => Proc.new { |source| source.as_at_date }
  validates_presence_of :period_end, :unless => Proc.new { |source| source.as_at_date }

  validates_presence_of :as_at_date, :unless => Proc.new { |source| source.period_start }

  before_validation :set_period_start
  before_validation :set_period_end

  class << self
    
    def get_data_source file_name
      if exists?(:file => file_name)
        find_by_file(file_name)
      else
        date = Date.parse(file_name[/(\d\d\d\d-\d\d-\d\d)/, 1])
        name = "Register of Members' Financial Interests #{date.to_s(:dd_month_year).reverse.chomp('0').reverse}"
        yy = date.to_s[2..3]
        mm = date.to_s[5..6]
        dd = date.to_s[8..9]
        url = "http://www.publications.parliament.uk/pa/cm/cmregmem/#{yy}#{mm}#{dd}/memi02.htm"
        parliament = Organisation.find_by_name('Parliament')
        create!({ :file => file_name,
            :name => name, :long_name => name, :url => url,
            :organisation_id => parliament.id, :as_at_date => date })
      end
    end

    def merge_periods(data_sources)
      sorted = data_sources.sort_by(&:period_start)
      dates = [[sorted.first.period_start]]
      if sorted.size > 1
        sorted.each_with_index do |source, index|
          next_index = index.next
          unless (sorted.size - 1) < next_index
            next_source = sorted[next_index]
            unless adjacent?(source.period_end, next_source.period_start)
              dates.last << source.period_end
              dates << [next_source.period_start]
            end
          end
          dates.last << sorted.last.period_end unless dates.last.size == 2
        end
      else
        dates.last << sorted.first.period_end
      end
      dates
    end
    
    def adjacent? date, other_date
      date.next_month == other_date
    end

  end
  
  def period_start_text
    if @period_start_text
      @period_start_text
    else
      period_start ? period_start.to_s(:month_year) : ''
    end
  end

  def period_start_text= text
    @period_start_text = text
  end

  def period_end_text
    if @period_end_text
      @period_end_text
    else
      period_end ? period_end.to_s(:month_year) : ''
    end
  end

  def period_end_text= text
    @period_end_text = text
  end

  protected

    def set_period_start
      if @period_start_text
        begin
          self.period_start = Date.parse @period_start_text
        rescue
          self.period_start = nil
        end
      end
    end

    def set_period_end
      if @period_end_text
        begin
          self.period_end = Date.parse @period_end_text
        rescue
          self.period_end = nil
        end
      end
    end

end
