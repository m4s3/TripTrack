require 'test_helper'

class LikeTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    @user1 = users(:archer)
    # This code is not idiomatically correct.
    @micropost = @user.microposts.build(content: "Lorem ipsum")
    @like = @user1.likes.build(micropost: @micropost)
  end
  
  test "should be valid" do
    assert @like.valid?
  end
  
  test "user id should be present" do
    @like.user= nil
    assert_not @like.valid?
  end

  test "micropost should be present" do
    @like.micropost = nil
    assert_not @like.valid?
  end

end
