# frozen_string_literal: true
require 'spec_helper'
require 'rails_helper'

class SessionsControllerSpec
  describe SessionsController do
    before do
      allow(controller).to receive(:set_current_user)
    end
    # let(:user) { instance_double(User, id: 1, email: "valid@gmail.com", session_token: 'fake_session_token') }
    describe "the sessions#create method" do
      it "should pick up a session for a logged in individual" do
      get :new
      @user = User.find_by_email("testuser@gmail.com")
      @session_token = @user.session_token
      post :create, params: {session: {email: @user.email, password: "Password!1"}}
      expect(session["session_token"]).to eq(@session_token)
      end
      it "should pick up a session for a logged in individual" do
        get :new
        @user = User.new({:email => "testuser50000@gmail.com", :password => "Password!1", :password_confirmation => "Password!1", :name => "Student1",:music_experience => "0", :clinical_experience => "1-2", :general_education => "0", :access_level => "Student", :new_user => true})
        @user.update(new_user: true)
        expect(@user.new_user).to be true
        post :create, params: {session: {email: @user.email, password: "Password!1"}}
        puts flash[:notice]
      end
      it "should not create a session if the user does not exist" do
        @user = User.find_by_email("testuser@gmail.com")
        @session_token = @user.session_token
        post :create, params: {session: {email: @user.email, password: "password"}}
        expect(session["session_token"]).to eq(nil)
      end
    end
    describe "the sessions#destroy method" do
      it "should delete a session if a user logs out" do
      @user = User.where(email: "testuser@gmail.com").first
      controller.instance_variable_set(:@current_user, @user)
      delete :destroy
      expect(flash[:notice]).to eq("Successfully logged out")
      end
      it "should delete a session if a user logs out & change their status to no longer be a new user" do
        @user = User.new({:email => "testuser1@gmail.com", :password => "Password!1", :password_confirmation => "Password!1", :name => "Student1",:music_experience => "0", :clinical_experience => "1-2", :general_education => "0", :access_level => "Student", :new_user => true})
        controller.instance_variable_set(:@current_user, @user)
        delete :destroy
        expect(flash[:notice]).to eq("Successfully logged out")
      end
    end
  end
end
