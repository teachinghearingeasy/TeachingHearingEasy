class QuizzesController < ApplicationController
  before_action :set_quiz, only: [:show, :edit, :update, :destroy]

  # GET /quizzes
  # GET /quizzes.json
  def index
    render file: "#{Rails.root}/public/404.html", status: :not_found
  end

  # GET /quizzes/1
  # GET /quizzes/1.json
  def show
    if @quiz.which_grbas_letter.empty?
      render :show_test
    else
      render :show
    end
  end

  # GET /quizzes/new
  def new
    @quiz = Quiz.new
  end

  # GET /quizzes/1/edit
  def edit
  end

  # POST /quizzes
  # POST /quizzes.json
  def create
    @quiz, error = Quiz.build_quiz params[:quiz][:which_grbas_letter],
                            params[:quiz][:difficulty].to_i,
                            params[:quiz][:num_questions].to_i,
                            @current_user.id
    if not @quiz.nil? and @quiz.save
      flash[:notice] = "Quiz created successfully!"
      unless @current_user.nil?
        @current_user.quizzes << @quiz
      end
      redirect_to quiz_path(@quiz)
    else
      flash[:alert] = error
      @quiz = Quiz.new
      render :new
    end
  end

  def create_test
    if request.post?
      @quiz, error = Quiz.build_test params[:quiz][:difficulty].to_i,
                                     params[:quiz][:num_questions].to_i,
                                     @current_user.id
      if not @quiz.nil? and @quiz.save
        flash[:notice] = "Test created successfully!"
        unless @current_user.nil?
          @current_user.quizzes << @quiz
        end
        redirect_to quiz_path(@quiz)
      else
        flash[:alert] = error
        @quiz = Quiz.new
        render :create_test
      end
    else
      @quiz = Quiz.new
      render :create_test
    end
  end

  # PATCH/PUT /quizzes/1
  # PATCH/PUT /quizzes/1.json
  # app/controllers/quizzes_controller.rb
def update
  @quiz = Quiz.find(params[:id])
  num_right = 0
  complete = ActiveModel::Type::Boolean.new.cast(quiz_params[:complete])
  quiz_params[:responses].each do |response|
    @response = Response.find_by_id(response[0])
    feedback = ""
    # Tests should have response for each question
    ['g', 'r', 'b', 'a', 's'].each do |letter|
      letter_sym = "#{letter}_rating".to_sym
      # Quiz will only pass this once
      unless response[1][letter_sym].nil? || response[1][letter_sym].empty?
        @response.update({ letter_sym => response[1][letter_sym], # letter_sym is g_rating, r_rating, etc.
                           :reasoning => response [1][:reasoning], :quiz_id => @quiz.id })
        # Test feedback is each letter and its feedback on their own lines
        feedback_string, correct = @response.create_feedback(letter)
        feedback = feedback + "\n#{letter.upcase}: " + feedback_string
        num_right += 1 if correct
      end
      @response.update({ :feedback => feedback })
    end
  end
  # This should pass true for completed if the user submits but not if they click save
  @quiz.update({ :completed => complete, :num_right => num_right })
  if @quiz.save
    if complete
      flash[:notice] = "Quiz/Test completed successfully! Find your results in Quiz or Test History!"
    else
      flash[:notice] = "Quiz/Test saved successfully! Return to it later through Quiz or Test History!"
    end
    # Redirect to page where their results are one click away
    redirect_to user_path(@current_user.id)
  else
    render :edit
  end
end


  # DELETE /quizzes/1
  # DELETE /quizzes/1.json
  def destroy
    @quiz.destroy
    respond_to do |format|
      format.html { redirect_to quizzes_url, notice: 'Quiz was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quiz
      @quiz = Quiz.find(params[:id])
      @responses = @quiz.responses
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def quiz_params
      params.require(:quiz).permit(:which_grbas_letter, :difficulty, :num_questions, :complete,
                                   responses: [:g_rating, :r_rating, :b_rating, :a_rating, :s_rating, :reasoning])
    end

    def test_params
      params.require(:quiz).permit(:difficulty, :num_questions, responses: [:rating, :reasoning])
    end
end
