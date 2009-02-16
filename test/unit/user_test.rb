require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "user has a name" do
    user = users(:one)
    user.name = ""
    assert ! user.valid?
    assert user.errors.on(:name)
  end
  
  test "user name is unique" do
    user = User.new(
      :name => "joshua",
      :hashed_password => "funny?",
      :salt => "no, stupid"
    )
    assert ! user.valid?
    assert user.errors.on(:name)
  end
  
  test "password is confirmed" do
    user = User.new(
      :name => "beaker",
      :password => "face!",
      :password_confirmation => "" #=> bad!
    )
    
    assert ! user.valid?
    assert user.errors.on(:password)
  end
  
  test "blank password throws an error" do
    user = User.new(
      :name => "bunson",
      :password => "",
      :password_confirmation => "" #=> bad!
    )
    
    assert ! user.valid?
    assert user.errors.on(:base)
    assert_match /Missing password/, user.errors["base"]
  end
  
  test "user gets authenticated" do
    user = users(:one)
    assert User.authenticate(user.name, 'boo')
  end
  
  test "bad password does not get us authenticated" do
    user = users(:one)
    assert ! User.authenticate(user.name, 'foo')
  end
  
  test "user not found" do
    assert ! User.authenticate('baba', 'yaga')
  end
end
