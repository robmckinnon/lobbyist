class FormerRole < ActiveRecord::Base

  belongs_to :appointee

  before_validation :set_leaving_service_date

  validates_presence_of :title
  validates_presence_of :leaving_service_date

  def leaving_service_date_text
    if @leaving_service_date_text
      @leaving_service_date_text
    else
      leaving_service_date ? leaving_service_date.to_s(:month_year) : ''
    end
  end

  def leaving_service_date_text= text
    @leaving_service_date_text = text
  end

  protected

  def set_leaving_service_date
    if @leaving_service_date_text
      begin
        self.leaving_service_date = Date.parse @leaving_service_date_text
      rescue
        self.leaving_service_date = nil
      end
    end
  end
end
