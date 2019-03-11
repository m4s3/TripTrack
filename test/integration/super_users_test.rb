require 'test_helper'

class SuperUsersTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:malory)
    @super= users(:super)
  end
  
  test "should a user become a super user or a super user become a user " do
    log_in_as(@user)
    assert_not @user.super_user? 
    archer  = users(:archer)
    #assert_not @user.friend?(archer)
    @user.require_friend(archer)
    #assert @user.pending_request?(archer)
    @user.accepted_friend(archer)
    #assert @user.friend?(archer)
    @user.check_super
    assert  @user.super_user?
    @user.delete_friend(archer)
    @user.check_super
    assert_not  @user.super_user?
                    
  end
  
  
 
  
  
end