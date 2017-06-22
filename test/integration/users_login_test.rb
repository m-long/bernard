require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user       = users(:matt)
    @other_user = users(:archer)
    @admin      = users(:mallory)
  end

  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?, "Flash message persisting too long"
  end

  test "login with valid information followed by logout" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email:   @user.email,
                                         password: 'P@ssw0rd' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path,       count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    assert flash.empty?
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # Simulate a user clicking logout in a second window.
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "login with valid information followed by additional login" do
    get login_path
    assert_template 'sessions/new'
    log_in_as(@user)
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    log_in_as(@other_user)
    assert_redirected_to @user
    follow_redirect!
  end

  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    # Cookies in tests require string keys, not hash keys. Annoying.
    assert_equal cookies['remember_token'], assigns[:user].remember_token
    assert_not_nil cookies['remember_token']
  end

  test "login without remembering" do
    log_in_as(@user, remember_me: '0')
    # Cookies in tests require string keys, not hash keys. Annoying.
    assert_nil cookies['remember_token']
  end
end
