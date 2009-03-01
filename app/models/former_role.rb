class FormerRole < ActiveRecord::Base

  belongs_to :appointee

  validates_presence_of :leaving_service_date

  def leaving_service_date_text
    if leaving_service_date
      leaving_service_date.to_s(:month_year)
    else
      ''
    end
  end

  def leaving_service_date_text= text
    begin
      self.leaving_service_date = Date.parse text
    rescue
      errors.add('leaving_service_date', 'Please enter a valid month and year')
    end
  end

end
