class StatisticsController < ApplicationController
  before_action :verify_admin, only: [:site_statistics]
  before_action :verify_teacher, only: [:group_statistics]

  def user_statistics
    @user = User.find(params[:id])
    @quiz_results = @user.get_individual_quiz_grades
    @test_results = @user.get_test_grades
    byebug
  end

  def group_statistics
  end

  def site_statistics
  end

  private

  def verify_admin
    redirect_to root_path, alert: 'Access denied.' unless current_user.admin?
  end

  def verify_teacher
    redirect_to root_path, alert: 'Access denied.' unless current_user.teacher?
  end
end
