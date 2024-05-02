# frozen_string_literal: true

class Stat < ActiveRecord::Base
  # Allows stat to be connected to user.id in database
  belongs_to :user

  # Function: set_progress_level sets the "progress level" of a user to either "beginner" or "intermediate" based on demographic data
  # If a user has less than 3 years of experience for all the fields combined they are considered beginner
  # (as standard for clinical years before CCC-SLP is 2 years); otherwise the user is considered
  # intermediate until they take the diagnostic test
  # Return type: None; updates model's progress level
  def set_progress_level
    user = User.find_by_id(self.user_id)
    experience = {:mus => user.music_experience, :clin => user.clinical_experience, :gen_ed => user.general_education}
    total_experience = 0
    experience.each_value do |value|
      if value.eql?("0")
        total_experience += 0
      elsif value.eql?("1-2")
        total_experience += 1.5
      elsif value.eql?("3-4")
        total_experience += 3.5
      else
        total_experience += 5
      end
    end
    if total_experience > 3
      progress_level = "intermediate"
    else
      progress_level = "beginner"
    end
    self.progress_level = progress_level
    self.save
  end

  # Function: update_experience updates the progress level of a  user based only on % correct answers on tests/quizzes
  # Progress level is updated based on how many correct answers the user has for completed quizzes only
  # Takes in "new_scores" a string value which is formatted as"#/#" where the first # is the numnber correct answers
  # and the second is the total number of questions the user has answered. If a user as above 60% accuracy
  # they are considered "intermediate", otherwise they are "beginner"
  # Return type: None; saves the new progress level for user everytime it's called and updates the scores
  def update_experience(new_scores)
    current_score = self.total_answers.split("/")
    correct_scores = current_score[0].to_i + new_scores[0]
    total_num = current_score[1].to_i + new_scores[1]
    unless total_num.eql?(0)
      if (correct_scores.to_f * 100 / total_num).round(2) > 60
        self.progress_level = "intermediate"
      else
        self.progress_level = "beginner"
      end
      self.total_answers = "#{correct_scores}/#{total_num}"
      self.save
    end
  end
end
