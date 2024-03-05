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
    end
  end
    # context 'with valid authentication' do
    #   before do
    #     allow(request.env['omniauth.auth']).to receive(:[]).with('provider').and_return(auth_hash['provider'])
    #     allow(request.env['omniauth.auth']).to receive(:[]).with('uid').and_return(auth_hash['uid'])
    #     allow(User).to receive(:find_by_provider_and_uid).with(auth_hash['provider'], auth_hash['uid']).and_return(user)
    #     allow(User).to receive(:create_with_omniauth).with(auth_hash).and_return(user)
    #   end

end
