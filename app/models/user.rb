class User < ActiveRecord::Base
  # Creates and saves a session token to remember user's information between sessions
  # Also makes sure emails are case insensitive in database
  before_save {|user| user.email=user.email.downcase}
  before_save :create_session_token

  # Defines the ability to be added to a group; NOT the owner, just people in the group
  has_and_belongs_to_many :groups, :join_table => "groups_users"

  # Used for tracking the "progress level" of user; see Stat model for description of
  # how progress tracking is established
  has_one :stats

  # Used to verify password fields with bcrypt
  has_secure_password

  #Validations: to confirm everything is formatted appropriately
  # Name: presence, and at a max length of 50 chars
  # Email: presence, accurate format: this@email.com are the only requirements to allow for max
  #       kinds of emails to be included,
  # Password: presence, formatting reqs: digit, lower case letter, upper case letter, and a symbol
  #        also has min reqs. for length
  # Password Confirm: does password field match password confirm (must match before user is added to database)
  # Music experience, clinical experience, and general education: Set as strings of numbers "0", "1-2","3-4", "5+" set as years; user enters these in view
  # Access Level: determines type of access: Admin, Developer, Professor, Student
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  # regex for a digit, lower case letter, upper case letter, and a symbol
  VALID_PASSWORD_REGEX = /\A(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[[:^alnum:]])/x
  validates :email, presence: true,
            format: {with: VALID_EMAIL_REGEX, message: " must be formatted correctly. The application accepts any email in an this@valid.email format."},
            uniqueness: {case_sensitive: false}
  validates :password,
            presence: true,
            format: {with: VALID_PASSWORD_REGEX, message: " must include a number (0-9), a lowercase and uppercase letter, and a symbol"},
            length: {minimum: 8}
  validates :password_confirmation, presence: true
  validates :music_experience, presence: true
  validates :clinical_experience, presence: true
  validates :general_education, presence: true
  validates :access_level, presence: true

  # Tracks and connects users to the quizzes/tests they have taken
  has_and_belongs_to_many :quizzes

  # Function: get_individual_quiz_grades obtains all the quizzes grades individual to letter for individual user
  # finds all quizzes the user has taken, checks whether the quiz has been completed
  # If the quiz has been completed it's added to a hash-map containing all GRBAS letters
  # to obtain overall number of questions and right answers for each letter
  # of the GRBAS scale
  # Return type: Hashmap [ "letter from GRBAS" => [num_right, total_num_questions]]
  def get_individual_quiz_grades
    # Get all quizzes for each letter
    quizzes = []
    letters = ['g', 'r', 'b', 'a', 's']
    letters.each do |letter|
      quiz_letter = self.quizzes.where('which_grbas_letter = ? AND completed IS true', letter)
      quizzes << quiz_letter
    end

    # Sum over these quizzes
    grades = []
    quizzes.each do |quiz_letter|
      letter_grades = [0,0]
      quiz_letter.each do |quiz|
        letter_grades[0] += quiz.num_right
        letter_grades[1] += quiz.num_questions
      end
      grades << letter_grades
    end

    # Zip map the letters to the grades
    Hash[letters.zip(grades)]
  end

  # Function: get_test_grades obtains all tests grades for individual user
  # Finds all the tests taken by individual user (marked by a lack of "GRBAS" letter in the "which_grbas_letter" property)
  # then finds which ones have been completed, and determines the total number of questions
  # and which ones were answered correctly
  # Return type: Array [num_right, total_num_questions]
  def get_test_grades
    tests = self.quizzes.where('which_grbas_letter = ? AND completed IS true', '')
    grades = [0,0]
    tests.each do |test|
      grades[0] += test.num_right unless test.num_right.nil?
      grades[1] += test.num_questions unless test.num_questions.nil?
    end
    grades
  end

  # Function: get_site_quiz_grades obtains all the quizzes grades individual to letter for entire database
  # finds all quizzes taken, checks whether the quiz has been completed
  # If the quiz has been completed it's added to a hash-map containing all GRBAS letters
  # to obtain overall number of questions and right answers for each letter
  # of the GRBAS scale
  # Return type: Hashmap [ "letter from GRBAS" => [num_right, total_num_questions]]
  def self.get_site_quiz_grades
    users = User.all
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

  # Function: get_test_grades obtains all tests grades for entire database
  # Finds all the tests (marked by a lack of "GRBAS" letter in the "which_grbas_letter" property)
  # then finds which ones have been completed, and determines the total number of questions
  # and which ones were answered correctly
  # Return type: Array [num_right, total_num_questions]
  def self.get_site_test_grades
    users = User.all
    total_test_scores = [0,0]
    for user in users
      test = user.get_test_grades
      unless test[0].nil? || test[1].nil?
        total_test_scores[0] += test[0]
        total_test_scores[1] += test[1]
      end
    end
    total_test_scores
  end

  # Private function: Used to create the initial session token for when users are created and saved
  # to database. Uses SecureRandom.urlsafe_base64 as a basis for creating session tokens
  # individual to users.
  private
  def create_session_token
    self.session_token = SecureRandom.urlsafe_base64
  end
end
