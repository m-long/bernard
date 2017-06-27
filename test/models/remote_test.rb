require 'test_helper'

class RemoteTest < ActiveSupport::TestCase

  #TODO tests for REGEX validation on all attributes

  def setup
    @test_remote    = remotes(:test_remote)
    @minimal_remote = remotes(:minimal_remote)
  end

  test "should be valid" do
    assert @test_remote.valid?
    assert @minimal_remote.valid?
  end

  ## name validation
  test "name should be present" do
    @test_remote.name = "   "
    assert_not @test_remote.valid?
  end

  test "name should be between 2 and 50 characters" do
    @test_remote.name = "a"
    assert_not @test_remote.valid?
    @test_remote.name = "a" * 50
    assert @test_remote.valid?
    @test_remote.name = "a" * 51
    assert_not @test_remote.valid?
  end
  
  ## brand validation
  test "brand should be present" do
    @test_remote.brand = "   "
    assert_not @test_remote.valid?
  end

  test "brand should be between 2 and 50 characters" do
    @test_remote.brand = "a"
    assert_not @test_remote.valid?
    @test_remote.brand = "a" * 50
    assert @test_remote.valid?
    @test_remote.brand = "a" * 51
    assert_not @test_remote.valid?
  end
end
