require 'rails_helper'

describe Schedule, type: :model do
	describe "initialization" do
		it "should have valid items" do
      schedule = build(:schedule) # has 4 items with identical periods
      expect( schedule ).to be_valid

      schedule = build(:schedule, :invalid)
      expect( schedule ).not_to be_valid
    end

    it "should calculate transfer and request availability periods totals and averages in minutes, for all items" do
			schedule = build(:schedule) # has 4 items with identical periods
      expect( schedule ).to be_valid

      schedule.calculate_availability_stats

			expect( schedule.transfer_availablity_total ).to be (4*180)
      expect( schedule.request_availablity_total ).to be (4*360)

			expect( schedule.transfer_availablity_avg ).to be 180.to_f
      expect( schedule.request_availablity_avg ).to be 360.to_f
		end
  end
end
