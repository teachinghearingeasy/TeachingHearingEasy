# frozen_string_literal: true

class ResponsesControllerSpec
  describe ResponsesController do
    describe "the responses#new and responses#create methods" do
      it "should show the responses the User has already created" do
        @user = User.where(email: "testuser@gmail.com").first
        controller.instance_variable_set(:@current_user, @user)
        get :show_responses, params: { :sound_id=>1 }
        expect(response).to be_successful
      end
    end
  end
end
