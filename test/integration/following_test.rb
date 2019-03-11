require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other = users(:archer)
    @super = users(:super)
    log_in_as(@user)
  end
  
  test "should follow a user the standard way" do
    assert_difference '@user.following.count', 1 do
      post relationships_path, params: { followed_id: @super.id }
    end
  end

 

  test "should unfollow a user the standard way" do
    @user.follow(@super)
    relationship = @user.active_relationships.find_by(followed_id: @super.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship)
    end
  end

 

  test "following page" do
    get following_user_path(@user)
    assert_not @user.following.empty?
    assert_match @user.following.count.to_s, response.body
    @user.following.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "followers page" do
    get followers_user_path(@super)
    assert_not @user.followers.empty?
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end
end