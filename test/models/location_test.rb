require 'test_helper'

class LocationTest < ActiveSupport::TestCase

  #TODO tests for REGEX validation on all attributes
  #TODO tests for dependent: :destroy

  def setup
    @bedroom     = locations(:bedroom)
    @living_room = locations(:living_room) 
    @other_user  = users(:lana)
  end

  test "should be valid" do
    assert @bedroom.valid?
    assert @living_room.valid?
  end

  ## name validation
  test "name should be present" do
    @bedroom.name = "   "
    assert_not @bedroom.valid?
  end

  test "name should be between 2 and 50 characters" do
    @bedroom.name = "a"
    assert_not @bedroom.valid?
    @bedroom.name = "a" * 50
    assert @bedroom.valid?
    @bedroom.name = "a" * 51
    assert_not @bedroom.valid?
  end

  test "location should be unique for the user" do
    same_name_location = Location.create(name: @bedroom.name,
                                         user: @other_user
                                        )
    assert same_name_location.valid?
    same_user_location = Location.create(name: "Different room name",
                                         user: @bedroom.user
                                        )
    assert same_user_location.valid?
    duplicate_location = Location.create(name: @bedroom.name,
                                         user: @bedroom.user
                                        )
    assert_not duplicate_location.valid?
  end

  ## user validations
  test "user should be present" do
    @bedroom.user = nil
    assert_not @bedroom.valid?
  end
end
