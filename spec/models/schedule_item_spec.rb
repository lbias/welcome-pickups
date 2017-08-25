require 'rails_helper'

describe ScheduleItem, type: :model do
	describe "initialization" do
    it "should have all fields in proper format" do
			schedule_item = build(:schedule_item)
      expect( schedule_item.valid? ).to_be true

      schedule_item = build(:schedule_item, transfer_available_from: nil)
      expect( schedule_item.valid? ).to_be false

      schedule_item = build(:schedule_item, transfer_available_from: 'invalid format')
      expect( schedule_item.valid? ).to_be false
    end

    it "should calculate transfer and request availability periods in minutes" do
			schedule_item = build(:schedule_item)
      expect( schedule_item.valid? ).to_be true

      expect( schedule_item.transfer_availablity ).to_eq 180
      expect( schedule_item.request_availablity ).to_be 360
		end
  end
end
