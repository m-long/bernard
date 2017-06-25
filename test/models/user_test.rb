require 'test_helper'

class UserTest < ActiveSupport::TestCase

  # TODO add validations for location dependent: :destroy and
  # that user.devices exists (through locations)
  # may also need to add in user.remotes too if can get functional

  def setup
    @user = User.new(first_name: "Example", last_name: "User", email: "user@example.com",
                    password: "foobar@3A", password_confirmation: "foobar@3A")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "first name should be present" do
    @user.first_name = "   "
    assert_not @user.valid?
  end

  test "last name should be present" do
    @user.last_name = "   "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end

  test "first name should not be too long" do
    @user.first_name = "a" * 51
    assert_not @user.valid?
  end

  test "first name should not be too short" do
    @user.first_name = "a" 
    assert_not @user.valid?
  end


  test "last name should not be too long" do
    @user.last_name = "a" * 51
    assert_not @user.valid?
  end

  test "last name should not be too short" do
    @user.last_name = "a" 
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email should not be too short" do
    @user.email = "x@y.z"
    assert_not @user.valid?
  end

  test "first name validation should accept valid names" do
    valid_first_names = %w[John jake Michelle art te-St a-a]
    valid_first_names.each do |valid_first_name|
      @user.first_name = valid_first_name
      assert @user.valid?, "#{valid_first_name} should be valid"
    end
  end

  test "first name validation should reject invalid names" do
    invalid_first_names = %w[C3-P0 3_ Jo_bob $$ # -_ a]
    invalid_first_names.each do |invalid_first_name|
      @user.first_name = invalid_first_name
      assert_not @user.valid?, "#{invalid_first_name} should be invalid"
    end
  end

  test "last name validation should accept valid names" do
    valid_last_names = %w[John jake Michelle art te-St a-a]
    valid_last_names.each do |valid_last_name|
      @user.last_name = valid_last_name
      assert @user.valid?, "#{valid_last_name} should be valid"
    end
  end

  test "last name validation should reject invalid names" do
    invalid_last_names = %w[C3-P0 3_ Jo_bob $$ # -_ a]
    invalid_last_names.each do |invalid_last_name|
      @user.last_name = invalid_last_name
      assert_not @user.valid?, "#{invalid_last_name} should be invalid"
    end
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn x@y.zz]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com x@y.z foo@bar..com x@..z]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end   

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "password validation should reject invalid passwords" do
    invalid_passwords = %w[foo f4A@ F4@DED @@@@@@ @3@3@3 F4=d3d]
    invalid_passwords.each do |invalid_password|
      @user.password = @user.password_confirmation = invalid_password
      assert_not @user.valid?, "#{invalid_password} should be invalid"
    end
  end

  test "password validation should accept valid passwords" do
    valid_passwords = %w[F4@d3d qw34ER%^]
    valid_passwords.each do |valid_password|
      @user.password = @user.password_confirmation = valid_password
      assert @user.valid?, "#{valid_password} should be valid"
    end
  end

  # Method Tests

  test "name should return user\'s full name" do
    assert_equal @user.full_name, "#{@user.first_name} #{@user.last_name}"
  end

  test "initial method should return user's initial" do
    assert_equal @user.initial, @user.first_name[0]
    assert_equal @user.initial, "E"
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end
end
