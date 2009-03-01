class Appointment < ActiveRecord::Base

  belongs_to :appointee

  def date_tendered_text
    if @date_tendered_text
      @date_tendered_text
    else
      date_tendered ? date_tendered.to_s(:month_year) : ''
    end
  end

  def date_tendered_text= text
    @date_tendered_text = text
  end

  def date_taken_up_text
    if @date_taken_up_text
      @date_taken_up_text
    else
      date_taken_up ? date_taken_up.to_s(:month_year) : ''
    end
  end

  def date_taken_up_text= text
    @date_taken_up_text = text
  end

  protected

  def set_date_tendered
    if @date_tendered_text
      begin
        self.date_tendered = Date.parse @date_tendered_text
      rescue
        self.date_tendered = nil
      end
    end
  end

  def set_date_taken_up
    if @date_taken_up_text
      begin
        self.date_taken_up = Date.parse @date_taken_up_text
      rescue
        self.date_taken_up = nil
      end
    end
  end
end
