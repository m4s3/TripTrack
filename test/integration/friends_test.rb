 require 'test_helper'

class FriendsTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    log_in_as(@user)

  end

  test "friends page" do
    get friends_user_path(@user)
    assert_match @user.friend.count.to_s, response.body
    @user.friend.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "request friends page" do
    get request_friends_user_path(@user)
    @user.friend.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

end
