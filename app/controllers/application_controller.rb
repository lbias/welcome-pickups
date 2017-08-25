class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :require_authentication

  def require_authentication
  	redirect_to '/login', notice: 'Sorry! You need to login first.' unless authenticated?
  end

  def redirect_if_authenticated
    redirect_to '/dashboard', notice: 'You are already authenticated!' if authenticated?
  end

  private

  # keeping auth data in session
  def current_driver_session
    @_current_driver_session ||=  DriverSession.new(session[:current_driver_session]||{})
  end
  helper_method :current_driver_session

  def authenticated?
    current_driver_session.try(:authenticated?)
  end
  helper_method :authenticated?  
end
