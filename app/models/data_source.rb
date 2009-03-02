class DataSource < ActiveRecord::Base

  has_friendly_id :name, :use_slug => true, :strip_diacritics => true

  belongs_to :organisation

  has_many :appointees

  validates_presence_of :name
  validates_uniqueness_of :name

  validates_presence_of :period_start
  validates_presence_of :period_end

  before_validation :set_period_start
  before_validation :set_period_end

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
