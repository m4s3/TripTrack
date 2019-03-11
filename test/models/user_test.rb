require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                      password: "foobar" ,password_confirmation: "foobar")
  end
  
  test "should super user be valid" do
    @user.super_user = true
    assert @user.valid?
  end
  
  
  test "should be valid" do
    assert @user.valid?
  end
  
  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end
  
  test "email should be present" do
    @user.email="      "
    assert_not @user.valid?
  end
  
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
  
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
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
    
      test "password should be present (nonblank)" do
        @user.password = @user.password_confirmation = " " * 6
        assert_not @user.valid?
      end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
  
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember,'')
  end
  
  
  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end
  
  test "should follow and unfollow a super user" do
    michael = users(:michael)
    archer  = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    assert archer.followers.include?(michael)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
  end
  
  test "should not follow and unfollow a basic user" do
    lana = users(:lana)
    archer  = users(:archer)
    assert_not archer.following?(lana)
    archer.follow(lana)
    assert_not archer.following?(lana)
  end
  
#FRIEND

  test "should add and delete a friend" do
    michael = users(:michael)
    archer  = users(:archer)
    assert_not michael.friend?(archer)
    michael.require_friend(archer)
    assert michael.pending_request?(archer)
    michael.accepted_friend(archer)
    assert michael.friend?(archer)
    assert michael.friends.include?(archer)
    michael.delete_friend(archer)
    assert_not michael.friend?(archer)
  end
  
  test "feed should have the right posts" do
    michael = users(:michael)
    archer  = users(:archer)
    lana    = users(:lana)
    # Posts from followed user
    lana.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end
    # Posts from self
    michael.microposts.each do |post_self|
      assert michael.feed.include?(post_self)
    end
    # Posts from unfollowed user
    archer.microposts.each do |post_unfollowed|
      assert_not michael.feed.include?(post_unfollowed)
    end
  end

#LIKE

  test "should like/unlike a post" do
    michael = users(:michael)
    archer  = users(:archer)
    micropost = michael.microposts.create!(content: "Lorem ipsum")
    assert archer.add_like(micropost.id)
    assert archer.liked_posts.include?(micropost)
    
  end
  
#PLACE
  
  test "should have place" do
    #michael = users(:michael)
    #funzione add place
  end



  
end