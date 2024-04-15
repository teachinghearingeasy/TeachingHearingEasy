# frozen_string_literal: true

class Group  < ActiveRecord::Base
  validates :name, presence: true
  validates :description, presence: true
  validates :owner, presence: true
  has_and_belongs_to_many :users, :join_table => "groups_users"

  before_save :generate_join_token

  def generate_join_token
    join_token = SecureRandom.hex(4)
    if Group.exists?(join_token: join_token)
      generate_join_token
    else
      self.join_token = join_token
    end
  end

  def owner?(user)
    user.id == owner
  end

  def self.find_group(join_token)
    if Group.exists?(join_token: join_token)
      @group = Group.where(join_token: join_token).first
    else
      false
    end
  end

  def get_group_quiz_grades
    # Use the user methods get individual quiz grades and add them up
    users = self.users
    total_quiz_hash = {}
    for user_id in users
      user = User.find_by_id(user_id)
      quiz_hash = user.get_individual_quiz_grades
      quiz_hash.each do |key, value|
        if total_quiz_hash[key]
          total_quiz_hash[key] += value
        else
          total_quiz_hash[key] = value
        end
      end
    end
    total_quiz_hash
  end

  def get_group_test_grades
    users = self.users
    total_test_scores = [0,0]
    for user_id in users
      user = User.find_by_id(user_id)
      test = user.get_test_grades
      total_test_scores[0] += test[0]
      total_test_scores[1] += test[1]
    end
    total_test_scores
  end

  def get_demographic_stats
    users = self.users
    average_experience = [0,0,0]
    for user_id in users
      user = User.find_by_id(user_id)
      user_demograph = ["none","none","none"]
      user_demograph[0] = user.music_experience
      user_demograph[1] = user.clinical_experience
      user_demograph[2] = user.general_education

      average_experience.each_index do |index|
        if user_demograph[index].eql?("0")
          average_experience[index] += 0
        elsif user_demograph[index].eql?("1-2")
          average_experience[index] += 1.5
        elsif user_demograph[index].eql?("3-4")
          average_experience[index] += 3.5
        else
          average_experience[index] += 5
        end
      end
    end

    average_experience.each_index do |index|
      average_experience[index] = (average_experience[index] / self.users.count).round(2)
    end
    average_experience
  end
end
