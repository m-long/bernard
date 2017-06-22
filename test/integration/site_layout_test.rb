require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:matt)
  end

  test "home page loads correctly" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "title", full_title
  end

  test "header loads properly" do
    get root_path
    assert_select "script[data-turbolinks-track=reload]", count: 1
    assert_select "link[rel=stylesheet]", count: 1
  end

  test "user signup page loads properly" do
    get signup_path
    assert_template 'users/new'
    assert_select "title", full_title("Sign Up")
    # Test the form partial is included properly
    assert_select "form[action=?]#new_user.new_user", signup_path, count: 1
  end

  test "user edit page loads properly" do
    log_in_as(@user)
    assert is_logged_in?
    get edit_user_path(@user)
    assert_template 'users/edit'
    assert_select "title", full_title("Edit #{@user.first_name}\'s Profile")
    # Test the form partial is included properly
    assert_select "form[action=?]#edit_user_#{@user.id}.edit_user", user_path(@user), count: 1
  end
end
