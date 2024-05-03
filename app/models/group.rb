# frozen_string_literal: true

class Group  < ActiveRecord::Base
  validates :name, presence: true
  validates :description, presence: true
  validates :owner, presence: true

  # Defines the ability to be added to a group; NOT the owner, just people in the group
  has_and_belongs_to_many :users, :join_table => "groups_users"

  before_save :generate_join_token

  # Function: generate_join_token creates the join token for the group which will be used to add users
  # to the group. Uses a simple SecureRandom.hex to establish a basic hexadecimal string
  # to be input by users. Also ensures that the join token is unique by checking any created
  # join tokens against all previous created ones.
  # Return type: None; saves the join token to the group
  def generate_join_token
    join_token = SecureRandom.hex(4)
    if Group.exists?(join_token: join_token) #regenerate token if it already exists
      generate_join_token
    else
      self.join_token = join_token
    end
  end

  # Function: owner? determines whether or not the current user is a owner of a group
  # by checking the user id of the owner against the current user's id.
  # Return type: bool for if the user is an owner
  def owner?(user)
    user.id == owner
  end

  # Function: find_group? finds a group based on the join token associated to that group.
  # If the token exists and is associated to a group then it returns the group
  # otherwise it will return a false value indicating no group could be found
  # Return type: Either group or false dependent on whether or not the group exists
  def self.find_group(join_token)
    if Group.exists?(join_token: join_token)
      # find the first instance group with the specified join token
      @group = Group.where(join_token: join_token).first
    else
      false
    end
  end

  # Function: get_group_quiz_grades retrieves all the group statistics for quizzes
  # first it finds all the users associated to a group and
  # calls the user method "get_individual_quiz_grades" then adds
  # the individual quiz stats to a hashmap containing the group's
  # total stats
  # Return type: Hashmap [ "letter from GRBAS" => [num_right, total_num_questions]]
  def get_group_quiz_grades
    # Use the user methods get individual quiz grades and add them up
    users = self.users
    total_quiz_hash = {}
    for user_id in users # get all users in group
      user = User.find_by_id(user_id)
      # Keys: GRBAS, Values: [num_correct, total_questions]
      quiz_hash = user.get_individual_quiz_grades # see user documentation for this method
      quiz_hash.each do |key, value|
        if total_quiz_hash[key] # if key already has some value stored, add the next value
          total_quiz_hash[key] +=  value
        else # otherwise store the value for that key
          total_quiz_hash[key] = value
        end
      end
    end

    # the total quiz hash stores each array in it's values
    # individually, this loop separates and adds them together
    # to appropriately create the return type desired
    final_hash = {}
    total_quiz_hash.each_key do |key|
      final_hash[key] = [0,0]
      total_quiz_hash[key].each_index do |index|
        if (index % 2).eql?(0) # even index; stores total correct answers
          final_hash[key][0] += total_quiz_hash[key][index]
        else # odd index; stores total number of questions
          final_hash[key][1] += total_quiz_hash[key][index]
        end
      end
    end

    final_hash
  end

  # Function: get_group_test_grades retrieves all the group statistics for tests
  # first it finds all the users associated to a group and
  # calls the user method "get_individual_test_grades" then adds
  # the individual test stats to an array containing the group's
  # total stats
  # Return type: Array [num_right, total_num_questions]
  def get_group_test_grades
    users = self.users
    total_test_scores = [0,0]
    for user_id in users # get all users in group
      user = User.find_by_id(user_id)
      test = user.get_test_grades # see user documentation for this method
      total_test_scores[0] += test[0]
      total_test_scores[1] += test[1]
    end
    total_test_scores
  end

  # Function: get_demographic_stats gets the demographic data for all users in a group and
  # returns the average experience in years for each individual category of demographic data.
  # First it finds all the users in a group, then it retrieves their demographic data (stored as an array)
  # and adds it to the group demographic data for the total experience for each individual stat.
  # Then divides the total by the number of users in the group to determine the
  # average experience level of a group of users.
  # Return type: Array [int for average music experience, int for average clinical experience, int for general education]
  def get_demographic_stats
    users = self.users
    average_experience = [0,0,0] # [music, clinic, gen ed] experience
    for user_id in users  # get all users in group
      user = User.find_by_id(user_id)
      user_demograph = ["none","none","none"] # get individual demographic data
      user_demograph[0] = user.music_experience
      user_demograph[1] = user.clinical_experience
      user_demograph[2] = user.general_education

      average_experience.each_index do |index| # add individual to group
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

    average_experience.each_index do |index| # divide by number of users to find average experience
      average_experience[index] = (average_experience[index] / self.users.count).round(2)
    end
    average_experience
  end
end
