# frozen_string_literal: true
require 'spec_helper'
require 'rails_helper'

class GroupsControllerSpec
  describe GroupsController do
    describe "The groups#new and groups#create methods" do
      it "creates a new user object in the new method" do
        @user = User.where(email: "testuser@gmail.com").first
        controller.instance_variable_set(:@current_user, @user)
        expect(Group).to receive(:new)
        get :new
      end
      it "saves a new group to the database in the create method if the user is a professor" do
        @user = User.where(email: "testuser@gmail.com").first
        controller.instance_variable_set(:@current_user, @user)
        post :create, params: { group:  {:name => "Group 2", :description => "testing group"}}
        expect(flash[:notice]).to eq("New group created!")
      end
      it "does not save a new group if the parameters to create a new group are wrong" do
        @user = User.where(email: "testuser@gmail.com").first
        controller.instance_variable_set(:@current_user, @user)
        post :create, params: { group: {:description => "testing group"} }
        expect(flash[:notice]).to have_content("Validation failed with errors")
      end
    end
    describe "the groups#index method" do
      it "shows the groups a professor has created" do
        @user = User.where(email: "testuser@gmail.com").first
        @group = Group.create({:name => "Group 2", :description => "testing group", :owner => 1})
        controller.instance_variable_set(:@current_user, @user)
        get :index
        @groups = controller.instance_variable_get(:@groups)
        @group_ex = @groups.find_by_name("Group 1")
        expect(@group_ex.name).to eq("Group 1")
      end
      it "shows the groups a student has joined" do
          @user = User.where(email: "testuser1@gmail.com").first
          @group = Group.where(name: "Group 1").first
          @user.groups << @group
          controller.instance_variable_set(:@current_user, @user)
          get :index
          @groups = controller.instance_variable_get(:@groups)
          @group_ex = @groups.find_by_name("Group 1")
          expect(@group_ex.name).to eq("Group 1")
      end
    end
  end
end
