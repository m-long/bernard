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

  test "name should be present" do
    @samsung.name = "   "
    assert_not @samsung.valid?
  end

  test "name should be between 2 and 50 characters" do
    @samsung.name = "a"
    assert_not @samsung.valid?
    @samsung.name = "a" * 51
    assert_not @samsung.valid?
  end

  test "name should be unique" do
    same_brand = RemoteBrand.create(name: @samsung.name)
    assert_not same_brand.valid?
  end
end
