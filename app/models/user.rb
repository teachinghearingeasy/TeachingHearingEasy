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

  private
  def create_session_token
    self.session_token = SecureRandom.urlsafe_base64
  end
end
