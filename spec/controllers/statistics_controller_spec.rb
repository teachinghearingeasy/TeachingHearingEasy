# frozen_string_literal: true

class StatisticsControllerSpec
  describe StatisticsController do
    describe "#user_statistics method" do
      it "should return the statistics related to the current user's stats for quizzes and tests" do
        @user = User.where(email: "testuser@gmail.com").first
        controller.instance_variable_set(:@current_user, @user)
        get :user_statistics, params: { :id => 1}
        @quiz_result = controller.instance_variable_get(:@quiz_results)
        expect(@quiz_result["g"]).to eq([0,0])
      end
    end
    describe "#group_statistics" do
      it "should return the statistics for quizzes and tests of a group the user is viewing" do
        @user = User.where(email: "testuser@gmail.com").first
        controller.instance_variable_set(:@current_user, @user)
        @group = Group.find_by_owner(@user.id)
        second_user = User.where(email: "testuser2@gmail.com").first
        third_user = User.create({:email => "unittesters@gmail.com", :password => "Password!1", :password_confirmation => "Password!1", :name => "Student2", :music_experience => "1-2", :clinical_experience => "3-4", :general_education => "5+", :access_level => "Student"})
        @group.users << second_user
        @group.users << third_user
        get :group_statistics, params: { :join_token => @group.join_token}
        expect(response).to be_successful
      end
      it "should not display statistics if the group does not exist" do
        @user = User.where(email: "testuser@gmail.com").first
        controller.instance_variable_set(:@current_user, @user)
        get :group_statistics, params: { :join_token => 1}
        @group = controller.instance_variable_get(:@group)
        expect(@group).to eq(false)
      end
      it "should not display statistics if the group does exist but the current user is not the owner" do
        @user = User.where(email: "testuser@gmail.com").first
        second_user = User.where(email: "testuser2@gmail.com").first
        controller.instance_variable_set(:@current_user, second_user)
        @group = Group.find_by_owner(@user.id)
        @group.users << second_user
        get :group_statistics, params: { :join_token => @group.join_token}
        expect(flash[:alert]).to include("Access denied")
      end
    end
    describe "@site_statistics" do
      it "should provide site wide statistics for all users" do
        @user = User.where(email: "matthew-speranza@uiowa.edu").first
        controller.instance_variable_set(:@current_user, @user)
        get :site_statistics
        expect(response).to be_successful
      end
    end
  end
end
