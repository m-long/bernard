require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path
    assert_template 'users/new'
    assert_no_difference 'User.count' do
      post users_path, params: { user: { first_name:  "",
                                         last_name: "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    assert_not is_logged_in?
    assert_select 'div#error_explanation'
    assert_select 'div.alert.alert-danger'
  end

  test "valid signup information with account activation" do
    get signup_path
    assert_template 'users/new'
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { first_name:  "Example",
                                         last_name: "User",
                                         email: "user@example.com",
                                         password:              "P@ssw0rd",
                                         password_confirmation: "P@ssw0rd" } }
    end
    # Ensures exactly 1 email was delivered
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    # Try to log in before activation
    log_in_as(user)
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_not flash.empty?
    assert_select 'div.alert.alert-warning'
    # Invalid activation token
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_not flash.empty?
    assert_select 'div.alert.alert-danger'
    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong@email.com')
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_not flash.empty?
    assert_select 'div.alert.alert-danger'
    # Valid activation token and email
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    assert_redirected_to user
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
    assert_not flash.empty?
    assert_select 'div.alert.alert-success'
  end
end
