class StatisticsController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_admin, only: [:site_statistics]
  before_action :verify_teacher, only: [:group_statistics]

  def user_statistics
    @user = User.find(params[:id])
  end

  def group_statistics
  end

  def site_statistics
  end

  private

  def verify_admin
    redirect_to root_path, alert: 'Access denied.' unless current_user.admin?
  end
end
