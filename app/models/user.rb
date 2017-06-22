class User < ApplicationRecord

  # Token validation
  ## Attribute accessor for remember, activation, and reset tokens
  attr_accessor :remember_token, :activation_token, :reset_token
  before_create :create_activation_digest

  # Name validations
  ## Force user first and last names to be between 3 and 50 characters
  ## Names also must only use valid characters, but can be any language
  VALID_NAME_REGEX = /\A[\p{L}-]+\z/
  validates :first_name,
              presence: true,
              length: { in: 2..50 },
              format: { with: VALID_NAME_REGEX }
  validates :last_name,
              presence: true,
              length: { in: 2..50 },
              format: { with: VALID_NAME_REGEX }

  # Email validations
  ## Ensure emails in db are lowercase
  before_save :downcase_email
  ## For emails to have relatively adequate formatting
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email,
              presence: true,
              length: { in: 6..255 },
              format: { with: VALID_EMAIL_REGEX },
              uniqueness: { case_sensitive: false  }

  # Password validations
  ## Add in secure password using Rails method; require password_digest on model
  has_secure_password
  ## Regex for one lower case letter, one upper case letter, a digit, and a symbol
  VALID_PASSWORD_REGEX = /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*(_|[-+_!@#$%^&*.,?])).+\z/
  validates :password,
              presence: true,
              length: { minimum: 6 },
              format: { with: VALID_PASSWORD_REGEX },
              allow_nil: true

  # Methods
  ## Methods for handling user names
  def full_name
    "#{first_name} #{last_name}"
  end

  def initial
    first_name[0] if !first_name.empty?
  end

  ## Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  ## Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  ## Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  ## Activates an account
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  ## Sends an activation email
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  ## Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest:  User.digest(reset_token), 
                   reset_sent_at: Time.zone.now)
  end

  ## Sends a password reset email
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  ## Returns true if a password reset has expired
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Class Methods
  class << self
    ## Returns the hash digest of the given string
    def User.digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    ## Returns a random token
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # Private methods
  private
    
    ## Converts email to all lowercase
    def downcase_email
      email.downcase!
    end

    ## Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
