# frozen_string_literal: true
require 'spec_helper'
require 'rails_helper'

class PagesControllerSpec
  describe PagesController do
    it "should render the about page" do
      @user = User.where(email: "testuser@gmail.com").first
      controller.instance_variable_set(:@current_user, @user)
      get :about
      expect(response).to be_successful
    end
  end
end
