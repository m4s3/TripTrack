require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest
  test "should redirect create if not legged in" do
    get likes_create_url
    assert_redirected_to login_url
  end

  test "should redirect delete if not ligged in" do
    get likes_delete_url
    assert_redirected_to login_url
  end

end
