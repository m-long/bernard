require 'test_helper'

class DeviceTest < ActiveSupport::TestCase

  #TODO tests for REGEX validation on all attributes
  #TODO tests for associations

  def setup
    @bedroom_tv           = devices(:bedroom_tv)
    @bedroom_sound_system = devices(:bedroom_sound_system)
    @bedroom              = locations(:bedroom)
    @living_room          = locations(:living_room)
  end

  test "should be valid" do
    assert @bedroom_tv.valid?
  end

  ## name validation
  test "name should be present" do
    @bedroom_tv.name = "   "
    assert_not @bedroom_tv.valid?
  end

  test "name should be between 2 and 50 characters" do
    @bedroom_tv.name = "a"
    assert_not @bedroom_tv.valid?
    @bedroom_tv.name = "a" * 50
    assert @bedroom_tv.valid?
    @bedroom_tv.name = "a" * 51
    assert_not @bedroom_tv.valid?
  end

  test "name should exist once per location" do
    same_name_tv = Device.create(name: @bedroom_tv.name,
                                 location: @living_room,
                                 device_model: @bedroom_tv.device_model
                                )
    assert same_name_tv.valid?
    same_location_tv = Device.create(name: "Another Bedroom Device",
                                     location: @bedroom_tv.location,
                                     device_model: @bedroom_tv.device_model
                                    )
    assert same_location_tv.valid?
    duplicate_tv = Device.create(name: @bedroom_tv.name,
                                 location: @bedroom_tv.location,
                                 device_model: @bedroom_tv.device_model
                                )
    assert_not duplicate_tv.valid?
  end

  ## location validation
  test "location should be present" do
    @bedroom_tv.location = nil
    assert_not @bedroom_tv.valid?
  end

  ## device_model validation
  test "device_model should be present" do
    @bedroom_tv.device_model = nil
    assert_not @bedroom_tv.valid?
  end
end
