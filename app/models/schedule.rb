# tableless model, to handle schedule logic
class Schedule
	include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :items,
   :transfer_availablity_total,
   :request_availablity_total,
   :transfer_availablity_avg,
   :request_availablity_avg

  # -- Validations

  validates_presence_of :items
  validate :has_valid_items?

  def has_valid_items?
  	if items.present? && items.size > 0 && items.select{ |item| item.valid? }.blank?
  		errors.add(:items, "All items are invalid!")
  	end
  end

  # -- Initializaiton

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def initialize(items_json='')
    @items = from_json items_json

  end

  def from_json schedule_json
  end

  # -- Calculations

  def calculate_availability_stats
  	return if @items.blank?

  	@transfer_availablity_total = 0
  	@request_availablity_total = 0

  	@items.each do |item|
  		item.calculate_availability
	  	@transfer_availablity_total += item.transfer_availablity
	  	@request_availablity_total += item.request_availablity
  	end

  	@transfer_availablity_avg = @transfer_availablity_total.to_f /
  		@items.size
  	@request_availablity_avg = @request_availablity_total.to_f /
  		@items.size
  end
end
