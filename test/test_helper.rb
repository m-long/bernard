ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  # Include ApplicationHelper for application methods
  include ApplicationHelper

  # Add more helper methods to be used by all tests here...

  def setup
    @base_title="mattlong.la"
  end

  # Returns true if a test user is logged in
  def is_logged_in?
    session.exists? && !session[:user_id].nil?
  end

  def is_user_logged_in?(user)
    is_logged_in? && session[:user_id] == user.id
  end

  # Log in as a particular user
  def log_in_as(user)
    session[:user_id] = user.id
  end

  # Log in as a particular user
  def log_in_as(user, password: 'P@ssw0rd', remember_me: '1')
    post login_path, params: { session: { email:    user.email,
                                          password: password,
                                          remember_me: remember_me } }
  end
end
