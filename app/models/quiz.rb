class Quiz < ActiveRecord::Base
  has_many :responses
  # allows quizzes to track and load which songs are associated to a particular quiz
  has_and_belongs_to_many :sounds, :join_table => "quiz_sounds"
  # allows quizzes to track and load which responses are associated to a particular quiz
  has_and_belongs_to_many :responses, :join_table => "quizzes_responses"
  # allows quizzes to associate which quiz is associated to which user
  has_and_belongs_to_many :users
  # creates an Array for the quiz_answers property
  serialize :quiz_answers, Array, :coder => JSON

  #Validations:
  # Difficulty - validates presence
  # Num questions - validates presence
  validates :difficulty, presence: true
  validates :num_questions, presence: true

  # Function: build_quiz creates a quiz based off of the inputs given by the user
  # and the user id. Takes in the letter of the scale, the "difficulty" (scale level)
  # selected by the user and the number of questions for that quiz. Then saves the quizzes
  # and creates all the empty Response objects to be saved and used during the quiz. Uses
  # the get_sound method and does require users to select what scale level they are looking to practice.
  # Return type: None; saves the quiz, selects sounds and responses associated to that quiz
  def self.build_quiz(grbas_letter, difficulty, num_questions, user_id)
    # Assert that the grbas_letter is valid
    quiz = Quiz.new

    grbas_letter.downcase!
    if ["g", "r", "b", "a", "s"].include?(grbas_letter) && difficulty >= 0 && num_questions > 0
      quiz = Quiz.new(which_grbas_letter: grbas_letter)
      # Get the sounds for the quiz based on num_questions and difficulty
      # 0 is hard, 1 is medium, 2 is medium, 3 is easy
      question_answers = []
      sounds = []
      responses = []
      0.upto(num_questions - 1) do |i|
        question_answers << (generate_random_number(difficulty, 1)).round.to_i % 4
        sound = Sound.get_sound(grbas_letter, question_answers[i])

        count = 0
        while sounds.include?(sound) && count < 100
          count += 1
          question_answers << (generate_random_number(difficulty, 1)).round.to_i % 4
          sound = Sound.get_sound(grbas_letter, question_answers[i])
        end
        if count == 100 or sound.nil?
          error_message = "Could not find enough unique sounds for the quiz. Try another difficulty setting."
          return nil, error_message
        end
        sounds << sound
        quiz.sounds << sound

        response = Response.new(sound_id: sound.id, quiz_id: quiz.id, user_id: user_id)
        response.save
        responses << response
      end

      quiz.responses = responses
      quiz.quiz_answers = question_answers
      quiz.user_id = user_id
      quiz.difficulty = difficulty
      quiz.num_questions = num_questions
      quiz.created_at = DateTime.now
      end
    quiz
  end

  # Function: build_test creates a test based off of the inputs given by the user
  # and the user id. Takes in the "difficulty" (scale level)
  # assigned by the controller and the number of questions for that test. Then saves the test
  # and creates all the empty Response objects to be saved and used during the test. Uses
  # the get_sound method and does NOT require users to select what scale level they are looking to practice.
  # Return type: None; saves the test, selects sounds and responses associated to that test
  def self.build_test(difficulty, num_questions, user_id)
    quiz = Quiz.new
    if difficulty >= 0 && num_questions > 0
      # Get the sounds for the quiz based on num_questions and difficulty
      # 0 is hard, 1 is medium, 2 is medium, 3 is easy
      question_answers = []
      sounds = []
      responses = []
      0.upto(num_questions - 1) do |i|
        grbas_letter = ["g", "r", "b", "a", "s"].sample
        #Functionality for increasing test complexity, excluded due to limit in sounds
        # grbas_letter2 = ["g", "r", "b", "a", "s"].sample
        # sound = Sound.get_sound2(grbas_letter, grbas_letter2, question_answers[i])
        question_answers << (generate_random_number(difficulty, 1)).round.to_i % 4
        sound = Sound.get_sound(grbas_letter, question_answers[i])
        count = 0
        while sounds.include?(sound) && count < 100
          count += 1
          sound = Sound.get_sound(grbas_letter, question_answers[i])
          grbas_letter = ["g", "r", "b", "a", "s"].sample
          question_answers[i] = (generate_random_number(difficulty, 1)).round.to_i % 4
        end
        if count == 100 or sound.nil?
          error_message = "Could not find enough unique sounds for the test. Try another difficulty setting or less sounds."
          return nil, error_message
        end
        sounds << sound
        quiz.sounds << sound

        response = Response.new(sound_id: sound.id, quiz_id: quiz.id, user_id: user_id)
        response.save
        responses << response
      end

      quiz.which_grbas_letter = ""
      quiz.responses = responses
      quiz.quiz_answers = question_answers
      quiz.user_id = user_id
      quiz.difficulty = difficulty
      quiz.num_questions = num_questions
      quiz.created_at = DateTime.now
    end
    quiz
  end

  # Function: translate_letter takes in a GRBAS letter and returns the string
  # for the voice characteristic associated to that letter. I.E. Given "B" the
  # function returns "Breathiness"
  # Return type: String for voice characteristic
  def self.translate_letter(grbas_letter)
    case grbas_letter
    when "g"
        return "Grade"
    when "r"
        return "Roughness"
    when "b"
        return "Breathiness "
    when "a"
        return "Asthenia"
    when "s"
        return "Strain"
    else
        return "Unknown letter"
    end
  end


  # Private Function: generate_random_number takes in a mean value and
  # standard deviation and returns a random value centered on the mean
  # and within the range of a single standard deviation of the mean.
  private
  def self.generate_random_number(mean, std)
    gauss_rand = Random.new
    mean + gauss_rand.rand * std
  end
end
