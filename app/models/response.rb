class Response < ActiveRecord::Base
  belongs_to :sound
  has_and_belongs_to_many :quizzes, :join_table => "quizzes_responses"
  belongs_to :user

  def create_feedback(grbas_letter)
    quiz_letter = grbas_letter.downcase
    rating_sym = "#{quiz_letter}_rating".to_sym
    expert_score = Sound.find_by_id(self.sound_id).find_score(quiz_letter)
    if expert_score.eql? self[rating_sym].to_f
      correct_answers = ["That’s it! #{self[rating_sym]}!", "Good listening!", "You got it!", "Spectacular!",
                         "Golden!", "The ears have it!","That's speechy!","Super Duper!", "Super Laryngeal Perceptor!"]
      ran_ind = Random.rand(correct_answers.length)
      response = correct_answers[ran_ind]
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
        response = "This is a dysphonic voice. The experts put the level at G#{expert_score}."
      when "r"
        response = "This voice definitely has roughness present. The gold standard level was R#{expert_score}."
      when "b"
        response = "You might have heard the air in the sound. Our expert panel put the severity at B#{expert_score}."
      when "a"
        response = "This voice does sound weaker than a typical voice. The severity level is A#{expert_score}."
      when "s"
        response = "There tension or hyperfunction in this sample. The gold standard level was S#{expert_score}."
      else
        response = "Oops! Something went wrong on our end... Contact the developers for help."
      end
    end
    [response, expert_score.eql?(self[rating_sym].to_f)]
  end
end
