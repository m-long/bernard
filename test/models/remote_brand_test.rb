require 'test_helper'

class RemoteBrandTest < ActiveSupport::TestCase

  def setup
    @samsung = remote_brands(:samsung)
    @sony    = remote_brands(:sony)
  end

  test "should be valid" do
    assert @samsung.valid?
    assert @sony.valid?
  end

  ## name validation
  test "name should be in allowed list only" do
    @samsung.name = "Not In List"
    assert_not @samsung.valid?
    @samsung.name = "Samsung"
    assert @samsung.valid?
  end

  test "name should be between 2 and 50 characters" do
    @samsung.name = "a"
    assert_not @samsung.valid?
    @samsung.name = "a" * 51
    assert_not @samsung.valid?
  end
end
