require 'test_helper'

class DeviceBrandTest < ActiveSupport::TestCase

  def setup
    @samsung = device_brands(:samsung)
    @sony    = device_brands(:sony)
  end

  test "should be valid" do
    assert @samsung.valid?
    assert @sony.valid?
  end

  test "name should be between 2 and 50 characters" do
    @samsung.name = "a"
    assert_not @samsung.valid?
    @samsung.name = "a" * 51
    assert_not @samsung.valid?
  end

  test "name should be unique" do
    same_brand = DeviceBrand.create(name: @samsung.name)
    assert_not same_brand.valid?
  end
end
