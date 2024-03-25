class User < ActiveRecord::Base
  before_save {|user| user.email=user.email.downcase}
  before_save :create_session_token

  has_and_belongs_to_many :groups, :join_table => "groups_users"

  has_secure_password
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  # validates presence of a digit, lower case letter, upper case letter, and a symbol
  VALID_PASSWORD_REGEX = /\A(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[[:^alnum:]])/x
  validates :email, presence: true,
            format: {with: VALID_EMAIL_REGEX},
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

  has_and_belongs_to_many :quizzes

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

  def get_test_grades
    tests = self.quizzes.where('which_grbas_letter = ? AND completed IS true', '')
    grades = [0,0]
    tests.each do |test|
      grades[0] += test.num_right
      grades[1] += test.num_questions
    end
    grades
  end

  private
  def create_session_token
    self.session_token = SecureRandom.urlsafe_base64
  end
end
