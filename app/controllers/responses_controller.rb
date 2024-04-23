class ResponsesController < ApplicationController
  before_action :set_current_user

  def show_responses
    @sound = Sound.find(params[:sound_id])
    @quiz_responses, @test_responses = Response.find_and_split_responses(@current_user, @sound)
    @quiz_rating, @quiz_letter = Response.get_quiz_info(@quiz_responses)
  end
end
