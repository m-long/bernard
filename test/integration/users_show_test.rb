require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest

  def setup
    @user          = users(:matt)
    @other_user    = users(:archer)
    @admin         = users(:mallory)
    @inactive_user = users(:cyril)
  end

  test "admins can view inactive user profiles" do
    get user_path(@inactive_user)
    assert_redirected_to root_url
    follow_redirect!
    assert flash.empty?
    log_in_as(@admin)
    get user_path(@inactive_user)
    assert_template 'users/show'
    assert_select 'em', text: "User Inactive", count: 1
    assert flash.empty?
  end
end
