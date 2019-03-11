class FriendshipsController < ApplicationController
  before_action :logged_in_user
  


  
  #deve essere il corretto user 
  
  def create
    @friend = User.find(params[:friend_id])
    if @friend.super_user?
      redirect_to(root_url)
      return
    end
    current_user.require_friend(@friend)
    msg = { resource: current_user.name+" has just sent you a request friend" ,
            friend_id: params[:friend_id],
            user_id: current_user.id
          }  
    $redis.publish 'rt-change', msg.to_json
    redirect_to request.referrer
    
  end

  def destroy
    @other_user=Friendship.find(params[:id]).friend
    msg=nil
    if current_user?(@other_user)
      @user=User.find(params[:user_id])
       msg = { resource: current_user.name+" has just removed you as friend" ,
            friend_id: @user.id,
            user_id: current_user.id
          } 
    else
      @user=current_user
       msg = { resource: current_user.name+" has just removed you as friend" ,
            friend_id: @other_user.id,
            user_id: current_user.id
          } 
    end
     @user.delete_friend(@other_user)
   
   
    check_super_user(@user)
    check_super_user(@other_user)
    
    $redis.publish 'rt-change', msg.to_json
    redirect_to request.referrer
    
    

=begin
    respond_to do |format|
        format.html { redirect_to @user }
        format.js
      end
=end
  end

  def update
    @friend= Friendship.find(params[:id]).user #chi ha inviato la richiesta
    @friend.accepted_friend(current_user)
    flash[:success]="The user "+@friend.name+" is now your friend"
    check_super_user(current_user)
    check_super_user(@friend)
    redirect_to request.referrer
    
    
  end
  
  private
    def check_super_user(user)
      user.check_super
      
    end
    
   

end
