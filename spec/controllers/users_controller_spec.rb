# frozen_string_literal: true
require 'spec_helper'
require 'rails_helper'

class UsersControllerSpec
  describe UsersController do
    describe "The users#new and users#create methods" do
      it "creates a new user object in the new method" do
        expect(User).to receive(:new)
        get :new
      end
      it "saves a new user to the database in the create method" do
        post :create, params: { user: {:email => "random_email@email.com", :password => "Password!1", :password_confirmation => "Password!1", :name => "Valid Name", :music_experience => "0", :clinical_experience => "0", :general_education => "0", :access_level => "Student"} }
        expect(flash[:notice]).to eq("Sign up successful! Welcome to THE!")
      end
      it "does not save a new user if the parameters to create a new user are wrong" do
        post :create, params: { user: {:password => "Password!1", :password_confirmation => "Password!1", :name => "Valid Name", :music_experience => "0", :clinical_experience => "0", :general_education => "0", :access_level => "Student"} }
        expect(flash[:notice]).to have_content("Validation failed with errors")
      end
    end
    describe "the users#show method" do
      it "shows the correct user's profile if they are logged in" do
        @user = User.where(email: "testuser@gmail.com").first
        controller.instance_variable_set(:@current_user, @user)
        get :show, params: {id: @user.id}
        expect(response).to be_successful
      end
      it "shows the correct user's profile if the user tries to open an account they shouldn't" do
        @user = User.where(email: "testuser@gmail.com").first
        controller.instance_variable_set(:@current_user, @user)
        get :show, params: {id: @user.id+1}
        expect(flash[:warning]).to eq("Can only show profile of logged-in user")
      end
    end
    describe "users#history methods (quiz and test)" do
      it "should return nil if there are no quiz histories for a user" do
        @user = User.where(email: "testuser@gmail.com").first
        controller.instance_variable_set(:@current_user, @user)
        @quiz_history = (get :quiz_history, params: {id: @user.id}).body
        expect(@quiz_history.length).to eq(0)
      end
      it "should return nil if there are no quiz histories for a user" do
        @user = User.where(email: "testuser@gmail.com").first
        controller.instance_variable_set(:@current_user, @user)
        @test_history = (get :test_history, params: {id: @user.id}).body
        expect(@test_history.length).to eq(0)
      end
    end
    describe "users#join_group methods" do
      it "should render join group page and join a group if the join token for the group does exist" do
        @user = User.where(email: "testuser2@gmail.com").first
        @group = Group.where(name: "Group 1").first
        controller.instance_variable_set(:@current_user, @user)
        get :open_join_group, params: {id: @user.id }
        post :join_group, params: {id: @user.id, user: {join_token: @group.join_token}}
        expect(response).to redirect_to(groups_path)
      end
      it "should not join a group if the join token for the group does not exist" do
        @user = User.where(email: "testuser2@gmail.com").first
        controller.instance_variable_set(:@current_user, @user)
        post :join_group, params: {id: @user.id, user: {join_token: "0000111"}}
        expect(flash[:notice]).to eq("Please try again, group code was either incorrect or group does not exist")
      end
      it "should not join a group if the join token for the group does not exist" do
        @user = User.where(email: "testuser1@gmail.com").first
        @group = Group.where(name: "Group 1").first
        @user.groups << @group
        controller.instance_variable_set(:@current_user, @user)
        post :join_group, params: {id: @user.id, user: {join_token: @group.join_token}}
        expect(flash[:notice]).to eq("You've already joined this group. Please check the existing groups tab.")
      end
    end
    describe "users#search_users methods" do
      it "should successfully send a list of users" do
        @user = User.where(email: "matthew-speranza@uiowa.edu").first
        controller.instance_variable_set(:@current_user, @user)
        get :search_users
      end
      it "should successfully send an empty list of users when no search terms are given" do
        @user = User.where(email: "matthew-speranza@uiowa.edu").first
        controller.instance_variable_set(:@current_user, @user)
        get :search_users, params: {:search => "testuser@gmail.com"}
        @users = controller.instance_variable_get(:@users)
        expect(@users.length).to eq(1)
      end
    end
    describe "users#search_users methods" do
      it "should change access of the appropriate user when called" do
        @user = User.where(email: "matthew-speranza@uiowa.edu").first
        controller.instance_variable_set(:@current_user, @user)
        post :change_access, params: {:access => "Admin", :id => 1}
        @user = controller.instance_variable_get(:@user)
        expect(@user.access_level).to eq("Admin")
      end
      it "should not change access of a developer or admin" do
        @user = User.where(email: "matthew-speranza@uiowa.edu").first
        controller.instance_variable_set(:@current_user, @user)
        post :change_access, params: {:access => "Admin", :id => @user.id}
        @user = controller.instance_variable_get(:@user)
        expect(flash[:alert]).to eq("You cannot change the access level of yourself or admins.")
      end
      it "should not change access if the acess level is not among the lit of pre-defined access levels" do
        @user = User.where(email: "matthew-speranza@uiowa.edu").first
        controller.instance_variable_set(:@current_user, @user)
        post :change_access, params: {:access => "None", :id => 1}
        @user = controller.instance_variable_get(:@user)
        expect(flash[:alert]).to eq("Failed to change access level. This is case sensitive and must match 'Admin', 'Student', or 'Professor'")
      end
      it "should not change access of a user when the current user is not a developer or admin" do
        @user = User.where(email: "testuser2@gmail.com").first
        controller.instance_variable_set(:@current_user, @user)
        post :change_access, params: {:access => "Professor", :id => 2}
        expect(flash[:alert]).to eq("Access denied.")
      end
    end
  end
end
