class Response < ActiveRecord::Base
  # allows responses to track which sound is associated to a particular response
  belongs_to :sound
  # allows quizzes to track and load which responses are associated to a particular quiz
  has_and_belongs_to_many :quizzes, :join_table => "quizzes_responses"
  # allows responses to associate which response is associated to which user
  belongs_to :user


  # Function: create_feedback takes in the letter of the quiz/test that the response
  # is associated to and returns the feedback that is associated to the user's answer.
  # Specifically, if a user's answer is the same as the GRBAS rating for that sound
  # then the function returns a string containing positive feedback otherwise it will return
  # negative feedback based on the user's answer.
  # Return type: [string containing feedback, bool determining if the answer was correct]
  def create_feedback(grbas_letter)
    quiz_letter = grbas_letter.downcase
    rating_sym = "#{quiz_letter}_rating".to_sym
    expert_score = Sound.find_by_id(self.sound_id).find_score(quiz_letter)
    if expert_score.eql? self[rating_sym].to_f
      correct_answers = ["That’s it! #{self[rating_sym]}!", "Good listening!", "You got it!", "Spectacular!",
                         "Golden!", "The ears have it!","That's speechy!","Super Duper!", "Super Laryngeal Perceptor!"]
      ran_ind = Random.rand(correct_answers.length)
      response = correct_answers[ran_ind] + " The experts scored this sample at " + quiz_letter.upcase + expert_score.to_i.to_s
    elsif expert_score.eql? 0.0
      case quiz_letter
      when "g"
        response = "Not quite. Our experts rated this voice as within normal limits or G0. The voice may not be perfect, but is it a voice that would stand out if you heard it in a public place (ie walking down a street)?"
      when "r"
        response = "No roughness here. A voice that is rough has an irregular wave form and sounds bumpy, unclear, or growly. The gold standard rating puts this one at R0"
      when "b"
        response = "Breathiness is caused by the escape of excess air at the glottis. The experts found this sample to be B0 or without any airy quality"
      when "a"
        response = "This voice is pretty typical when it comes to weakness. A weak voice may sound soft or under powered. Our gold standard rating didn't identify weakness for this sample, A0."
      when "s"
        response = "Strain usually sounds like some is working too hard or the voice is tight or tense. The composite voice rating for this sample was S0 or no strain present."
      else
        response = "Oops! Something went wrong on our end... Contact the developers for help."
      end
    else
      case quiz_letter
      when "g"
        response = "This is a dysphonic voice. The experts put the level at G#{expert_score.to_i}."
      when "r"
        response = "This voice definitely has roughness present. The gold standard level was R#{expert_score.to_i}."
      when "b"
        response = "You might have heard the air in the sound. Our expert panel put the severity at B#{expert_score.to_i}."
      when "a"
        response = "This voice does sound weaker than a typical voice. The severity level is A#{expert_score.to_i}."
      when "s"
        response = "There tension or hyperfunction in this sample. The gold standard level was S#{expert_score.to_i}."
      else
        response = "Oops! Something went wrong on our end... Contact the developers for help."
      end
    end
    [response, expert_score.eql?(self[rating_sym].to_f)]
  end

  # Function: get_num_responses determines how many responses there were for a quiz/test
  # which determines the basic number of questions the user answered for all quizzes/tests
  # and the answers the user made for each of those questions; lets users
  # see the history of their answers when viewing the sounds search
  # Return type: responses[] containing all the responses associated to a particular sound and user id
  def self.get_num_responses(sounds, uid)
    responses = []
    sounds.each do |sound|
      temp = Response.where(user_id: uid, sound_id: sound.id).where.not(feedback: nil)
      responses.push(temp.length)
      end
    responses
  end

  # Function: find_and_split_responses finds all responses from user that are complete and returns
  # an array of quiz responses then test responses
  # Return type: [quiz responses, test responses]
  def self.find_and_split_responses(user, sound)
    responses = where(user: user, sound: sound).where.not(feedback: nil)
    quiz_responses = []
    test_responses = []
    responses.each do |response|
      is_test = true
      %w[g r b a s].each do |letter|
        if response["#{letter}_rating".to_sym].nil?
          is_test = false
          break
        end
      end
      if is_test
        test_responses.push(response)
      else
        quiz_responses.push(response)
      end
    end
    [quiz_responses, test_responses]
  end

  # Function: get_quiz_info returns the score rating and letter for a quiz based on the
  # quiz responses given to the function (ie for every response given to the function,
  # it will return the letter and scale number associated to that response)
  # Return type: [quiz ratings, quiz letters]
  def self.get_quiz_info(quiz_responses)
    # Return the score rating & letter for each quiz based on #letter_rating values
    quiz_ratings = []
    quiz_letters = []
    quiz_responses.each do |response|
      rating = 0
      quiz_letter = ""
      %w[g r b a s].each do |letter|
        unless response["#{letter}_rating".to_sym].nil?
          rating = response["#{letter}_rating".to_sym]
          quiz_letter = letter
        end
      end
      quiz_ratings.push(rating)
      quiz_letters.push(quiz_letter)
    end
    [quiz_ratings, quiz_letters]
  end
end
