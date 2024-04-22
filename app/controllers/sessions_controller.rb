class SessionsController < ApplicationController
  skip_before_action :set_current_user
  def new
  end

  def create
    user = User.find_by_email(params["session"]["email"])
    if user && user.authenticate(params["session"]["password"])
      session["session_token"]= user.session_token
      @current_user = user
      if @current_user.new_user.eql?(true)
        flash[:notice] = "Welcome new user! Please take our quick tutorial!"
        redirect_to tutorial_path
      else
        flash[:notice] = "Log in successful!"
        redirect_to about_path
      end
    else
      flash[:alert] = 'Invalid email/password combination'
      redirect_to login_path
    end
  end

  def destroy
    session[:session_token]=nil
    @current_user=nil
    flash[:notice]= 'Successfully logged out'
    redirect_to about_path
  end
end
