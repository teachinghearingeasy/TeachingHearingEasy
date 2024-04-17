class StatisticsController < ApplicationController
  before_action :verify_admin, only: [:site_statistics]
  before_action :verify_teacher, only: [:group_statistics]

  def user_statistics
    @user = User.find(params[:id])
    @quiz_results = @user.get_individual_quiz_grades
    @test_results = @user.get_test_grades
    # byebug
  end

  def group_statistics
    @group = Group.find_group(params[:join_token])
    if @group == false
      redirect_to root_path, alert: 'Group not found.'
    elsif !@group.owner?(@current_user)
      redirect_to root_path, alert: 'Access denied. You are not the owner of this group.'
    end
    @quiz_results = @group.get_group_quiz_grades
    @test_results = @group.get_group_test_grades
    @demographic_results = @group.get_demographic_stats
  end

  def site_statistics
    @quiz_results = User.get_site_quiz_grades
    @test_results = User.get_site_test_grades
  end

  private

  def verify_admin
    redirect_to root_path, alert: 'Access denied.' unless @current_user.access_level.eql?("Admin")
  end

  def verify_teacher
    redirect_to root_path, alert: 'Access denied.' unless @current_user.access_level.eql?("Professor")
  end
end
