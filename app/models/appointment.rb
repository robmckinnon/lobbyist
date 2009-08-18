class Appointment < ActiveRecord::Base

  belongs_to :appointee
  belongs_to :organisation

  validates_presence_of :title
  validates_presence_of :organisation_name
  validates_presence_of :acoba_advice
  validates_presence_of :date_tendered
  validates_presence_of :date_taken_up

  before_validation :set_date_tendered
  before_validation :set_date_taken_up

  def person_name
    appointee.name
  end
  
  def person
    appointee.person
  end

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

  private

    def set_date_tendered
      self.date_tendered = Appointee.parse_date @date_tendered_text if @date_tendered_text
    end

    def set_date_taken_up      
      self.date_taken_up = Appointee.parse_date @date_taken_up_text if @date_taken_up_text
    end
end
