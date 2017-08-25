require 'rails_helper'

RSpec.describe DriverSessionsController, type: :controller do

	let(:driver_session) { build(:driver_session, :authenticable) }

	let(:valid_attributes) {{
    email: 'test@email.com',
    password: 'password',
    attempt_counter: '1'
  }}

  let(:authenticable_attributes) {{
    email: driver_session.email,
    password: driver_session.password,
    attempt_counter: '1'
  }}

  let(:invalid_attributes) {{
    email: 'testemail.com',
    password: nil,
    attempt_counter: nil
  }}

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # RunsController. Be sure to keep this updated too.
  let(:authed_session) {{
  	current_driver_session: {
        email: driver_session.email,
        token: driver_session.token
      }
  	}}

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end

    it "renders the new (login) template" do
      get :new
      expect(response).to render_template("new")
    end

    it "redirects to root if already authenticated" do
      get :new, session: authed_session
      expect(response).to redirect_to(root_url)
    end
  end

  describe "POST #create" do

  	it "redirects to root if already authenticated" do
      post :create, session: authed_session
      expect(response).to redirect_to(root_url)
    end

    context "with valid params" do
      it "email not found" do
        expect(controller.authenticated?).to be false

        post :create, params: {driver_session: valid_attributes}, session: {}

        expect(response).to have_http_status(:success)
        expect(controller.authenticated?).to be false
        expect(assigns(:driver_session).attempt_counter).to eq (authenticable_attributes[:attempt_counter].to_i + 1)
        expect(assigns(:driver_session).errors[:base].first).to match "Email not found"
      end

      it "email found but wrong password" do
        expect(controller.authenticated?).to be false
        authenticable_attributes[:password] = 'invalid password'

        post :create, params: {driver_session: authenticable_attributes}, session: {}

        expect(response).to have_http_status(:success)
        expect(controller.authenticated?).to be false
        expect(assigns(:driver_session).attempt_counter).to eq (authenticable_attributes[:attempt_counter].to_i + 1)
        expect(assigns(:driver_session).errors[:base].first).to match "Email found but password is wrong"
      end

      it "creates an authenticated driver session, and redirects to dashboard" do
        expect(controller.authenticated?).to be false

        post :create, params: {driver_session: authenticable_attributes}, session: {}

        expect(controller.authenticated?).to be true
        expect(response).to redirect_to(dashboard_url)
      end
    end

    context "with invalid params" do
      it "returns a success response, render 'new' template, and show errors" do
        post :create, params: {driver_session: invalid_attributes}, session: {}
        expect(response).to be_success
      	expect(response).to render_template("new")

				driver_session = assigns(:driver_session)
        expect(driver_session.valid?).to be false
        expect(driver_session.errors.present?).to be true
			end
    end
  end
end
