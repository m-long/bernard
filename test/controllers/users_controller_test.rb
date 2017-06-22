require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user          = users(:matt)
    @other_user    = users(:archer)
    @admin         = users(:mallory)
    @inactive_user = users(:cyril)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { first_name: @user.first_name,
                                              last_name:  @user.last_name,
                                              email:      @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    assert is_logged_in?
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    assert is_logged_in?
    patch user_path(@user), params: { user: { first_name: @user.first_name,
                                              last_name:  @user.last_name,
                                              email:      @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert is_logged_in?
    assert_not @other_user.admin?
    patch user_path(@other_user), params: { 
                                    user: { password:              "",
                                            password_confirmation: "",
                                            admin: true } }
    assert_not @other_user.reload.admin?, "User is now admin after web patch request"
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert is_logged_in?
    assert_not @other_user.admin?
    assert_no_difference 'User.count' do
      delete user_path(@user)

    end
    assert_redirected_to root_url
  end

  test "admins can delete users" do
    log_in_as(@admin)
    assert is_logged_in?
    assert_difference 'User.count', -1 do
      delete user_path(@user)
    end
  end

  test "should redirect edit when logged in as admin" do
    log_in_as(@admin)
    assert is_logged_in?
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as admin" do
    log_in_as(@admin)
    assert is_logged_in?
    patch user_path(@user), params: { user: { first_name: @user.first_name,
                                              last_name:  @user.last_name,
                                              email:      @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should not show inactive users to logged in regular users" do
    log_in_as(@user)
    assert is_user_logged_in?(@user)
    assert is_logged_in?
    get user_path(@inactive_user)
    assert_redirected_to root_url
    assert_not flash.empty?
    # Insure that the flash is empty after one redirect
    get user_path(@user)
    assert flash.empty?
  end

  test "should show inactive users to admins but not regular users" do
    get user_path(@inactive_user)
    assert_redirected_to root_url
    assert_not flash.empty?
    log_in_as(@admin)
    assert is_logged_in?
    get user_path(@inactive_user)
    assert_template 'users/show'
    assert flash.empty?
  end
end
