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
    for user in users
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
    total_test_scores = []
    for user in users
      test = user.get_test_grades
      total_test_scores[0] += test[0]
      total_test_scores[1] += test[1]
    end
    total_test_scores
  end
end
