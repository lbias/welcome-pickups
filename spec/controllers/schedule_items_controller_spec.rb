require 'rails_helper'

RSpec.describe ScheduleItemsController, type: :controller do

  let(:driver_session) { build(:driver_session, :authenticable) }

  let(:valid_authed_session) {{
    current_driver_session: get_valid_auth_header
  }}

  let(:authed_session) {{
  	current_driver_session: {
      email: driver_session.email,
      token: driver_session.token
    }
	}}

  describe "GET #index" do
    it "if not authenticated, redirects to login" do
      get :index, session: {}

      expect(response).to redirect_to(login_url)
    end

    it "if session exists, renders the index template" do
      get :index, session: authed_session

      expect(response).to render_template("index")
    end

    it "if not correctly authenticated, returns http success and error message" do
      get :index, session: authed_session

      expect(response).to have_http_status(:success)
      expect(flash["error"]).to match 'You need to sign in or sign up before continuing.'
    end


    it "if authenticated correctly, and dates are convenient, renders index and assigns schedule" do
      get :index, session: valid_authed_session

      expect(response).to render_template("index")
      schedule = assigns(:schedule)

      expect(schedule.present?).to be true
      expect(schedule.valid?).to be true

      # make sure that schedule data are built correctly
      expect(schedule.items.present?).to be true
      expect(schedule.items.size).to be > 0
      expect(schedule.transfer_availablity_total).to be > 0
      expect(schedule.request_availablity_total).to be > 0
      expect(schedule.transfer_availablity_avg).to be > 0
      expect(schedule.request_availablity_avg).to be > 0
    end

    it "if authenticated correctly, and dates are not convenient, renders index and show error" do
      inconvenient_dates = {
        from: 12.months.from_now,
        to: 13.months.from_now
      }
      get :index, params: inconvenient_dates, session: valid_authed_session

      expect(response).to render_template("index")
      schedule = assigns(:schedule)

      # schedule is created, but empty
      expect(schedule.present?).to be true
      expect(schedule.valid?).to be false

      # schedule hass error message
      expect(schedule.errors.present?).to be true
      expect(schedule.errors.full_messages.size).to be > 0
    end
  end
end
