require 'test_helper'

class TestHelpersTestTest < ActionDispatch::IntegrationTest

  def setup
    @user       = users(:matt)
    @other_user = users(:archer)
    @admin      = users(:mallory)
  end

  test "is_user_logged_in?(user) helper method functions" do
    log_in_as(@user)
    assert is_logged_in?
    assert is_user_logged_in?(@user)
    assert_not is_user_logged_in?(@other_user)
  end
end
