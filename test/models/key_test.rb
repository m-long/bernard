require 'test_helper'

class KeyTest < ActiveSupport::TestCase

  def setup
    @test_key = keys(:key_power)
  end

  test "should be valid" do
    assert @test_key.valid?
  end

  ## name validation
  test "name should be present" do
    @test_key.name = "   "
    assert_not @test_key.valid?
  end

  test "name should be between 2 and 50 characters" do
    @test_key.name = "a"
    assert_not @test_key.valid?
    @test_key.name = "a" * 50
    assert @test_key.valid?
    @test_key.name = "a" * 51
    assert_not @test_key.valid?
  end

  #TODO tests for REGEX validation on name

  ## value validation
  test "value should be present" do
    @test_key.value = "   "
    assert_not @test_key.valid?
  end

  test "value should be between 2 and 16 characters" do
    @test_key.value = "0"
    assert_not @test_key.valid?
    @test_key.value = "0xa"
    assert @test_key.valid?
    @test_key.value = "0x" + "a" * 14
    assert @test_key.valid?
    @test_key.value = "0x" + "a" * 15
    assert_not @test_key.valid?
  end

  test "value should be a valid hexidecimal string" do
    @test_key.value = "0xBADNUM"
    assert_not @test_key.valid?
  end

  #TODO tests for REGEX validation on value

  ## other validators
  test "name-value pair should be unique" do
    same_name_key = Key.create(name: @test_key.name, value: "0xd1ff")
    assert same_name_key.valid?
    same_value_key = Key.create(name: "KEY_DIFFERENT", value: @test_key.value)
    assert same_value_key.valid?
    duplicate_key = @test_key.dup
    assert_not duplicate_key.valid?
  end
end
