require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user          = users(:matt)
    @other_user    = users(:archer)
    @admin         = users(:mallory)
    @inactive_user = users(:cyril)
  end

  test "unsuccessful user edit" do
    log_in_as(@user)
    assert is_logged_in?
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { first_name:                  "   ",
                                              last_name:                   "   ",
                                              email:                 "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }
    assert_template 'users/edit'
    assert_select "div.alert.alert-danger", count: 1
  end

  test "successful user edit with friendly forwarding first time only" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert is_logged_in?
    assert_redirected_to edit_user_url(@user)
    # Make sure friendly forwarding is now done
    assert session[:forwarding_url].nil?
    first_name = "Foo"
    last_name  = "Bar"
    email      = "foo@bar.com"
    patch user_path(@user), params: { user: { first_name:            first_name,
                                              last_name:             last_name,
                                              email:                 email,
                                              password:              "",
                                              password_confimration: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal first_name, @user.first_name
    assert_equal last_name,  @user.last_name
    assert_equal email,      @user.email
  end
end
