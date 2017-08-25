class ScheduleItem
	include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :transfer_available_from,
   :transfer_available_to,
   :request_available_from,
   :request_available_to,
   :date,
   :transfer_availablity,
   :request_availablity

  # -- Validations

  validates_presence_of :transfer_available_from,
   :transfer_available_to,
   :request_available_from,
   :request_available_to,
   :date

  validates_format_of :transfer_available_from,
   :transfer_available_to,
   :request_available_from,
   :request_available_to,
   :with =>  /\d{2}:\d{2}/i

  validates_format_of :date,
   :with =>  /\d{4}-\d{2}-\d{2}/i

  # -- Initializaiton

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  # -- Calculations

  def calculate_availability
  	@transfer_availablity = duration( @transfer_available_from,
  	  @transfer_available_to)
  	@request_availablity = duration( @request_available_from,
  	  @request_available_to)
  end

  # -- Util

  def transfer_availablity_s
    "#{@transfer_available_from} - #{@transfer_available_to}"
  end

  def request_availablity_s
    "#{@request_available_from} - #{@request_available_to}"
  end

  # TODO move to helpers, and enhance

  def to_time time_string
  	hrs, mins = time_string.split(':')
  	Time.now.change({ hour: hrs.to_i, min: mins.to_i})
  end

  def duration from, to
  	minutes = ((to_time(to) - to_time(from)) / 1.minutes).to_i
  end
end
