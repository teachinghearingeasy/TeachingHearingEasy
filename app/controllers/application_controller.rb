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
