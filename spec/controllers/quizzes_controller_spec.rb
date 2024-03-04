# frozen_string_literal: true
require 'spec_helper'
require 'rails_helper'

class QuizzesControllerSpec
  describe QuizzesController do
    describe "the quizzes#index method" do
      it "should display a 404 error" do
        @user = User.where(email: "testuser@gmail.com").first
        controller.instance_variable_set(:@current_user, @user)
        get :index
        expect(response.status).to eq(404)
      end
    end
    describe "the quizzes#new and quizzes#create methods" do
      it "should create a new quiz object when new is called" do
        @user = User.where(email: "testuser@gmail.com").first
        controller.instance_variable_set(:@current_user, @user)
        expect(Quiz).to receive(:new)
        get :new
      end
      it "should create and save a new quiz with 1 sound when the create method is called correctly" do
        @user = User.where(email: "testuser@gmail.com").first
        controller.instance_variable_set(:@current_user, @user)
        post :create, params: {quiz: { which_grbas_letter: "g", difficulty: 0, num_questions: 1}}
        expect(flash[:notice]).to eq("Quiz created successfully!")
      end
      it "should create and save a new quiz with multiple sounds when the create method is called correctly" do
        @user = User.where(email: "testuser@gmail.com").first
        controller.instance_variable_set(:@current_user, @user)
        post :create, params: {quiz: { which_grbas_letter: "g", difficulty: 2, num_questions: 101}}
        expect(flash[:alert].include?("Could not find enough unique sounds for the quiz. Try another difficulty setting.")).to be true
      end
      it "should create and not save a quiz when the create method is called without all necessary parameters" do
        @user = User.where(email: "testuser@gmail.com").first
        controller.instance_variable_set(:@current_user, @user)
        post :create, params: {quiz: { which_grbas_letter: "g"}}
        @quiz = controller.instance_variable_get(:@quiz)
        expect(@quiz.which_grbas_letter).to eq(nil)
      end
    end
    describe "the quizzes#create_test method" do
      it "should create and save a new quiz with 1 sound when the create method is called correctly" do
        @user = User.where(email: "testuser@gmail.com").first
        controller.instance_variable_set(:@current_user, @user)
        post :create_test, params: {quiz: {difficulty: 0, num_questions: 1}}
        expect(flash[:notice]).to eq("Test created successfully!")
      end
      it "should create and save a new quiz with multiple sounds when the create method is called correctly" do
        @user = User.where(email: "testuser@gmail.com").first
        controller.instance_variable_set(:@current_user, @user)
        post :create_test, params: {quiz: {difficulty: 2, num_questions: 101}}
        expect(flash[:alert].include?("Could not find enough unique sounds for the test. Try another difficulty setting or less sounds")).to be true
      end
      it "should create and not save a quiz when the create method is called without all necessary parameters" do
        @user = User.where(email: "testuser@gmail.com").first
        controller.instance_variable_set(:@current_user, @user)
        post :create_test, params: {quiz: {which_grbas_letter: "g"}}
        @quiz = controller.instance_variable_get(:@quiz)
        expect(@quiz.which_grbas_letter).to eq(nil)
      end
      it "should create and not save a quiz when the create method is called with the correct HTTP request" do
        @user = User.where(email: "testuser@gmail.com").first
        controller.instance_variable_set(:@current_user, @user)
        get :create_test, params: {quiz: {difficulty: 2, num_questions: 1}}
        @quiz = controller.instance_variable_get(:@quiz)
        expect(@quiz.which_grbas_letter).to eq(nil)
      end
    end
    describe "the quizzes#show method" do
      it "should display a quiz when there's only 1 letter" do
        @user = User.where(email: "testuser@gmail.com").first
        controller.instance_variable_set(:@current_user, @user)
        @quiz = Quiz.new({:user_id => @user.id, :which_grbas_letter => "r", :difficulty => 1, :num_questions => 1})
        @sound = Sound.find_by_id(195)
        @response = Response.create({:r_rating => 1, :reasoning => "yuh", :sound_id => @sound.id, :user_id => @user.id})
        @quiz.sounds << @sound
        @quiz.responses << @response
        @quiz.save
        @response.save
        get :show, params: {id: @quiz.id}
        expect(response).to be_successful
      end
      it "should display an entire when there's only 1 letter" do
        @user = User.where(email: "testuser@gmail.com").first
        controller.instance_variable_set(:@current_user, @user)
        post :create_test, params: {quiz: {difficulty: 0, num_questions: 1}}
        @quiz = controller.instance_variable_get(:@quiz)
        get :show, params: {id: @quiz.id}
        expect(response).to be_successful
      end
    end
    describe "the quizzes#update method" do
      it "should update the quiz with the responses" do
        @user = User.where(email: "testuser@gmail.com").first
        controller.instance_variable_set(:@current_user, @user)
        post :create, params: {quiz: {which_grbas_letter: "g", difficulty: 0, num_questions: 1}}
        @quiz = controller.instance_variable_get(:@quiz)
        parameters = {:quiz => {:responses => {@quiz.responses.first.id => {:g_rating => 1, :reasoning => "duh" }}}, :id => @quiz.id}
        patch :update, params: parameters
        @quiz_response = Response.find_by_id(@quiz.responses.first.id)
        expect(@quiz_response.reasoning).to eq("duh")
        expect(@quiz_response.feedback).to_not eq(nil)
      end
    end
    describe "the quizzes#destroy method" do
      it "should delete the quiz if the destroy method is called" do
        @user = User.where(email: "testuser@gmail.com").first
        controller.instance_variable_set(:@current_user, @user)
        post :create, params: {quiz: {which_grbas_letter: "g", difficulty: 0, num_questions: 1}}
        @quiz = controller.instance_variable_get(:@quiz)
        @count = Quiz.count
        delete :destroy, params: {id: @quiz.id}
        expect(Quiz.count).to eq(@count-1)
      end
    end
  end
end
