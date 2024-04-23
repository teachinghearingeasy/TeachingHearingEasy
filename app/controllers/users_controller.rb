class UsersController < ApplicationController
  before_action :set_current_user, except: [:new, :create]
  before_action :verify_admin_or_dev, only: [:search_users, :change_access]

  def show
    id = params[:id]
    if !current_user?(id)
      flash[:warning]="Can only show profile of logged-in user"
      redirect_to user_path(@current_user.id)
    end
  end

  def search_users
    if params[:search].nil? || params[:search].empty?
      @users = []
    else
      @users = User.where("name LIKE ? OR email LIKE ?",
                          "%#{params[:search]}%".downcase, "%#{params[:search]}%".downcase)
    end
  end

  def change_access
  @user = User.find(params[:id])
  if @user == @current_user || (@user.access_level == "Admin" && @current_user.access_level != "Developer")
    flash[:alert] = "You cannot change the access level of yourself or admins."
    redirect_to search_users_path
    return
  end
  if params[:access] == "Admin" || params[:access] == "Student" || params[:access] == "Professor"
    @user.update_attribute(:access_level, params[:access])
  end
  if @user[:access_level] == params[:access]
    flash[:notice] = "Access level changed."
  else
    flash[:alert] = "Failed to change access level. This is case sensitive and must match 'Admin', 'Student', or 'Professor'"
  end
  render 'search_users'
end

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    @user.update({:new_user => true})
    if @user.save
      flash[:notice] = "Sign up successful! Welcome to THE!"
      @stat = Stat.create({:user_id => @user.id})
      @stat.save
      @stat.set_progress_level
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
    @quiz_history = @current_user.quizzes.where.not(which_grbas_letter: "").order(created_at: :desc)
  end

  def test_history
    @test_history = @current_user.quizzes.where(which_grbas_letter: "").order(created_at: :desc)
  end

  def open_join_group
    render 'join_group'
  end

  def join_group
    join_token = user_params[:join_token]
    @group = Group.find_group(join_token)
    if !@current_user.groups.include?(@group) && !@group.eql?(false)
      @current_user.groups << @group
      flash[:notice] ="You have just joined " + @group.name + "."
      redirect_to groups_path
    elsif @group.eql?(false)
      flash[:notice] = "Please try again, group code was either incorrect or group does not exist"
      render 'join_group'
    else
      flash[:notice] = "You've already joined this group. Please check the existing groups tab."
      render 'join_group'
    end
  end

  private
    def user_params
      params.require(:user).permit(:id, :name, :email, :address,:password,:password_confirmation,
                                   :music_experience, :clinical_experience, :general_education,
                                   :access_level, :join_token)
    end

    def verify_admin_or_dev
      redirect_to root_path, alert: 'Access denied.' unless @current_user.access_level.eql?("Admin") ||
        @current_user.access_level.eql?("Developer")
    end
end