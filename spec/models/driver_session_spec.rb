require 'rails_helper'

describe DriverSession, type: :model do
	describe "initialization" do
    it "should have email and passwords in proper format" do
			driver_session = build(:driver_session)
      expect( driver_session ).to be_valid

      driver_session = build(:driver_session, email: nil)
      expect( driver_session ).not_to be_valid

      driver_session = build(:driver_session, password: nil)
      expect( driver_session ).not_to be_valid

      driver_session = build(:driver_session, email: 'invalid format')
      expect( driver_session ).not_to be_valid
		end
  end
end
