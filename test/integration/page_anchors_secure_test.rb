require 'test_helper'

class PageAnchorsSecureTest < ActionDispatch::IntegrationTest

  # This test will need to be moved to a helper test eventually, and have a helper written
  # so that the helper can insert links with the proper rel

  def setup
    @user = users(:matt)
  end

  test "page anchors with target=_blank all have rel=noopener" do
    log_in_as @user
    assert is_logged_in?
    get edit_user_path(@user)
    assert_template 'users/edit'
    assert_select "a[target=_blank]" do
      assert_select "[rel=noopener]"
    end
  end
end
