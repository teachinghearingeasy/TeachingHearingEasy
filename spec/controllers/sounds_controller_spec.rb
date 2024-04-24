# frozen_string_literal: true
require 'spec_helper'
require 'rails_helper'

class SoundsControllerSpec
  describe SoundsController do
    describe "the sounds#index method" do
      it "should successfully get all sounds from the database" do
        @user = User.where(email: "testuser@gmail.com").first
        controller.instance_variable_set(:@current_user, @user)
        get :index
        @sounds = controller.instance_variable_get(:@sounds)
        expect(@sounds.size).to eq(Sound.all.size)
      end
    end
    describe "the sounds#new and sounds#create methods" do
      it "should create a new sound object when the new method is called" do
        @user = User.where(email: "testuser@gmail.com").first
        controller.instance_variable_set(:@current_user, @user)
        expect(Sound).to receive(:new)
        get :new
      end
      it "should create and save a new sound object when the correct parameters are given" do
        # Currently the system is not handling any creating new sounds or updating.
        # These tests should be editted once these features are implemented.
        @user = User.where(email: "testuser@gmail.com").first
        controller.instance_variable_set(:@current_user, @user)
        post :create
        expect(response.status).to eq(302)
      end
    end
    describe "the sounds#update method" do
      it "should update the sound object when parameters are provided" do
        # Currently the system is not handling any creating new sounds or updating.
        # These tests should be editted once these features are implemented.
        @user = User.where(email: "testuser@gmail.com").first
        controller.instance_variable_set(:@current_user, @user)
        put :update, params: {id: 1}
        expect(response.status).to eq(302)
      end
    end
    describe "the sounds#destroy method" do
      # Currently the system is not handling any creating new sounds or updating.
      # These tests should be editted once these features are implemented.
      it "should delete a sound when destroy is called" do
        @user = User.where(email: "testuser@gmail.com").first
        controller.instance_variable_set(:@current_user, @user)
        @sounds_count = Sound.count
        delete :destroy, params: {id: 1}
        expect(Sound.count).to eq(@sounds_count-1)
      end
    end
    describe "#search" do
      it "should return nothing if there are no search parameters" do
        @user = User.where(email: "testuser@gmail.com").first
        controller.instance_variable_set(:@current_user, @user)
        get :search, params: { :search => ""}
        expect(flash[:alert]).to eq("Search terms included all sounds!")
      end
      it "should return nothing if a grbas letter is not selected (even if ratings are selected)" do
        @user = User.where(email: "testuser@gmail.com").first
        controller.instance_variable_set(:@current_user, @user)
        get :search, params: { :search => "", :rating => 0}
        expect(flash[:alert]).to eq("You must select a letter to search by rating!")
      end
      it "should return nothing if a rating for the grbas letter is not selected (even if ratings are selected)" do
        @user = User.where(email: "testuser@gmail.com").first
        controller.instance_variable_set(:@current_user, @user)
        get :search, params: { search: "", :letter => "g"}
        expect(flash[:alert]).to eq("You must select a rating to search by letter!")
      end
      it "should return a list of sounds when a grbas letter and rating are selected" do
        @user = User.where(email: "testuser@gmail.com").first
        controller.instance_variable_set(:@current_user, @user)
        get :search, params: { search: "", :rating => 0, :letter => "g"}
        expect(flash[:notice]).to include("Found ")
      end
      it "should return an empty list of sounds when searching for a sound that doesn't exist" do
        @user = User.where(email: "testuser@gmail.com").first
        controller.instance_variable_set(:@current_user, @user)
        get :search, params: { search: "TEST"}
        @sound = controller.instance_variable_get(:@sounds)
        expect(flash[:alert]).to include("No sounds found!")
      end
    end
  end
end
