require 'test_helper'


class FriendshipsControllerTest < ActionDispatch::IntegrationTest
  
  test "create should require logged-in user" do
    assert_no_difference 'Friendship.count' do
      post friendships_path
    end
    assert_redirected_to login_url
  end
  
  test "update should require logged-in user" do
    assert_no_difference 'Friendship.count' do
      put friendship_path(friendships(:one))
    end
    assert_redirected_to login_url
  end
  
  test "destroy should require logged-in user" do
    assert_no_difference 'Friendship.count' do
      delete friendship_path(friendships(:one))
    end
    assert_redirected_to login_url
  end
end

