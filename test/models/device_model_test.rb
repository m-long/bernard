require 'test_helper'

class DeviceModelTest < ActiveSupport::TestCase
  
  #TODO tests for REGEX validation on all attributes
  #TODO tests for associations

  def setup
    @samsung_tv        = device_models(:samsung_tv)
    @sony_sound_system = device_models(:sony_sound_system)
    @tv                = device_types(:tv)
  end

  test "should be valid" do
    assert @samsung_tv.valid?
    assert @sony_sound_system.valid?
  end

  ## brand validation
  test "brand should be present" do
    @samsung_tv.brand = "   "
    assert_not @samsung_tv.valid?
  end

  test "brand should be in allowed list only" do
    @samsung_tv.brand = "Not In List"
    assert_not @samsung_tv.valid?
    @samsung_tv.brand = "Sony"
    assert @samsung_tv.valid?
  end

  test "brand should be between 2 and 50 characters" do
    @samsung_tv.brand = "a"
    assert_not @samsung_tv.valid?
    @samsung_tv.brand = "a" * 51
    assert_not @samsung_tv.valid?
  end

  ## device_type validation
  test "device_type should be present" do
    @samsung_tv.device_type = nil
    assert_not @samsung_tv.valid?
  end

  ## model validation
  test "model should be present" do
    @samsung_tv.model = "   "
    assert_not @samsung_tv.valid?
  end

  test "bmodel should be between 2 and 50 characters" do
    @samsung_tv.model = "a"
    assert_not @samsung_tv.valid?
    @samsung_tv.model = "a" * 50
    assert @samsung_tv.valid?
    @samsung_tv.model = "a" * 51
    assert_not @samsung_tv.valid?
  end

  test "model should be unique with brand" do
    same_model_tv = DeviceModel.create(brand: "Sony", 
                                       device_type: @tv,
                                       model: @samsung_tv.model
                                      )
    assert same_model_tv.valid?
    same_brand_tv = DeviceModel.create(brand: @samsung_tv.brand,
                                       device_type: @tv,
                                       model: "Different model"
                                      )
    assert same_brand_tv.valid?
    duplicate_tv = @samsung_tv.dup
    assert_not duplicate_tv.valid?
  end
end
