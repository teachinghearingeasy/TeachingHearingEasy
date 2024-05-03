/
This is the main controller for the application. It is responsible for setting
the current user and checking if the current user is the same as the user being accessed.
Most other controllers inherit from this controller and thus can access current user.
It also protects the application from forgery. The protect_from_forgery is giving the deployment
on the university server some issued.
/
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_current_user

  protected
  def set_current_user
    @current_user ||= User.find_by_session_token(session[:session_token])
    redirect_to login_path unless @current_user
  end

  def current_user?(id)
    @current_user.id.to_s == id
  end

end
