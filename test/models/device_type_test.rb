require 'test_helper'

class DeviceTypeTest < ActiveSupport::TestCase

  def setup
    @tv           = device_types(:tv)
    @sound_system = device_types(:sound_system)
  end

  test "should be valid" do
    assert @tv.valid?
    assert @sound_system.valid?
  end

  ## name validation
  test "name should be present" do
    @tv.name = "   "
    assert_not @tv.valid?
  end

  test "name should be between 2 and 50 characters" do
    @tv.name = "a"
    assert_not @tv.valid?
    @tv.name = "a" * 51
    assert_not @tv.valid?
  end

  test "name should be unique" do
    new_type = DeviceType.create(name: "New type")
    assert new_type.valid?
    dup_tv = DeviceType.create(name: @tv.name)
    assert_not dup_tv.valid?
  end
end
