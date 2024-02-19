class UsersController < ApplicationController
  before_action :set_current_user, only: [:show, :edit, :update, :destroy, :quiz_history, :open_join_group, :join_group]

  def user_params
    params.require(:user).permit(:id, :name, :email, :address,:password,:password_confirmation, :music_experience, :clinical_experience, :general_education, :access_level, :join_token)
  end

  def show
    id = params[:id]
    if !current_user?(id)
      flash[:warning]="Can only show profile of logged-in user"
      redirect_to user_path(@current_user.id)
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    if @user.save
      flash[:notice] = "Sign up successful! Welcome to THE!"
      redirect_to groups_path
    else
      errors = @user.errors.full_messages
      flash[:notice] = "Validation failed with errors: #{errors.join(', ')}"
      render 'new'
    end
  end

  def edit
    # render 'edit'
  end

  def update
    # update product
  end

  def destroy
    # destroy user
  end

  def quiz_history
    @quiz_history = @current_user.quizzes
  end

  def open_join_group
    render 'join_group'
  end

  def join_group
    join_token = user_params[:join_token]
    @group = Group.find_group(join_token)
    if !@current_user.groups.include?(@group) && !@group.eql?(false)
      @current_user.groups << @group
      redirect_to groups_path
    elsif @group.eql?(false)
      flash[:notice] = "Please try again, group code was either incorrect or group does not exist"
      render 'join_group'
    else
      flash[:notice] = "You've already joined this group. Please check the existing groups tab."
      render 'join_group'
    end
  end
end