class DriverSessionsController < ApplicationController
  before_action :set_driver_session, only: [:show, :destroy]

  # GET /driver_sessions/new
  def new
    @driver_session = DriverSession.new
  end

  # POST /driver_sessions
  # POST /driver_sessions.json
  def create
    @driver_session = DriverSession.new(driver_session_params)

    respond_to do |format|
      if @driver_session.save
        format.html { redirect_to @driver_session, notice: 'Driver session was successfully created.' }
        format.json { render :show, status: :created, location: @driver_session }
      else
        format.html { render :new }
        format.json { render json: @driver_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /driver_sessions/1
  # GET /driver_sessions/1.json
  def show
  end

  # DELETE /driver_sessions
  # DELETE /driver_sessions
  def destroy
    @driver_session.destroy
    respond_to do |format|
      format.html { redirect_to driver_sessions_url, notice: 'Driver session was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_driver_session
      # TODO get current session
      @driver_session = DriverSession.new
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def driver_session_params
      params.require(:driver_session).permit(:email, :password)#, :token)
    end
end
