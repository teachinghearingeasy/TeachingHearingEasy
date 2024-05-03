/
This is used for when a user searches a sound. There are links that allow the user to see past responses
to a particular sound. This controller serves that information.
/
class ResponsesController < ApplicationController
  before_action :set_current_user

  def show_responses
    @sound = Sound.find(params[:sound_id])
    @quiz_responses, @test_responses = Response.find_and_split_responses(@current_user, @sound)
    @quiz_rating, @quiz_letter = Response.get_quiz_info(@quiz_responses)
  end
end
