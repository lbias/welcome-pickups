class DriverSessionsController < ApplicationController
  # require '/lib/welcome_pickups_adapter.rb'
  include WelcomePickupsAdapter

  skip_before_action :require_authentication, :except => [:destroy]
  before_action :redirect_if_authenticated, :only => [:new, :create]

  # GET /driver_sessions/new
  # GET /login/new
  def new
    @driver_session = DriverSession.new
  end

  # POST /driver_sessions
  # GET /login/new
  def create
    @driver_session = DriverSession.new(driver_session_params)

    respond_to do |format|
      unless @driver_session.valid?
        # validate first, and save an API call if params are invalid
        format.html { render :new }
      else
        # start the API call to authenticate the driver
        begin
          result = authenticate_driver_session(@driver_session.to_auth_hash)
        rescue WelcomePickupsAdapter::WelcomePickupsException => e
          # something went wrong with the call
          @driver_session.errors[:base] << e.message
          format.html { render :new }
        else
          if result[:success]
            # if successfully authenticated, set the token into current user, for further authentication calls
            @driver_session.token = result[:token]
            set_current_driver_session
            # redirect to dashboard
            format.html { redirect_to '/dashboard', notice: 'Driver session was successfully authenticated.' }
          else
            # if authentication fails, update attempt counter, and show error
            @driver_session.attempt_counter = result[:attempt_counter]
            @driver_session.errors[:base] << result[:error]
            format.html { render :new }
          end
        end
      end
    end
  end

  # GET /driver_sessions/1
  # GET /driver_sessions/1.json
  def show
  end

  # DELETE /driver_sessions
  # DELETE /logout
  def destroy
    unset_current_driver_session
    respond_to do |format|
      format.html { redirect_to root_url, notice: 'Driver session was successfully destroyed.' }
    end
  end

  private
    def set_current_driver_session
      session[:current_driver_session] = @driver_session.auth_header_hash
      @_current_driver_session = @driver_session
    end

    def unset_current_driver_session
      @_current_driver_session = session[:current_driver_session] = nil
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def driver_session_params
      params.require(:driver_session).permit(:email, :password, :attempt_counter)#, :token)
    end
end
