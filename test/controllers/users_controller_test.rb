require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
   
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

#REDIRECT INDEX IF USER IS NOT LOGGED IN

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

#REDIRECT FOLLOW IF USER IS NOT LOGGED IN

  test "should redirect following when not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end


  test "should redirect followers when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to root_url
  end

#REDIRECT FRIEND IF USER IS NOT LOGGED IN

   test "should redirect firends when not logged in" do
    get friends_user_path(@user)
    assert_redirected_to login_url
  end

  test "should redirect request friend when not logged in" do
    get request_friends_user_path(@user)
    assert_redirected_to login_url
  end
  
#SIGN UP

  test "should get new" do
    get signup_path
    assert_response :success
  end

#REDIRECT EDIT IF USER IS NOT LOGGED IN

  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

#REDIRECT UPDATE IF USER IS NOT LOGGED IN
  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

#REDIRECT EDIT IF USER IS LOGGED IN AS WRONG USER

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

#REDIRECT UPDATE IF USER IS LOGGED IN AS WRONG USER

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

#REDIRECT DESTROY IF USER IS NOT LOGGED IN 

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

#REDIRECT DESTROY IF USER IS LOGGED IN AS NON-Admin

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end
  
end
