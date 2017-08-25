class ScheduleItemsController < ApplicationController
  # GET /schedule_items
  # GET /schedule_items.json
  def index
    @schedule_items = [ScheduleItem.new]
    @schedule = Schedule.new
  end
end
