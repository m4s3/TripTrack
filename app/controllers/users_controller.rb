class UsersController < ApplicationController
before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                       :friends , :request_friends , :following , :followers
                                       ]
                                       
                                      
before_action :correct_user,   only: [:edit, :update, :request_friends]
before_action :admin_user,     only: :destroy
before_action :super_user,     only:  :followers
  
 def request_friends
   @user = User.find(params[:id])
   #puts @user.id
   @users = @user.request_friends.paginate(page: params[:page])
   render 'show_request'
 end
 
 
 
 def friends                                           
    @user=User.find(params[:id])
    @friends =@user.friend.paginate(page: params[:page])
    render 'show_friends'
 end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  
  def show
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated
    @places=@user.places
    @hash = Gmaps4rails.build_markers(@places) do |place, marker|
      puts place.name, place.lat,place.lng      
      marker.lat place.lat
      marker.lng place.lng
      @photos=place.photos
      marker.infowindow render_to_string(:partial => "/users/map_pics", :formats => [:html], :locals => {:photos => @photos})
    end
    @microposts = @user.microposts.paginate(page: params[:page])
   # debugger
  end
  
  def new
    @user=User.new
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def edit
  end
  
  def index
    #@users = User.paginate(page: params[:page])
    @users = User.where(activated: true).paginate(page: params[:page])
  end
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
    
    # Before filters

    
    
    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
    
    def super_user
      @user=User.find(params[:id])
      redirect_to(root_url) unless @user.super_user?
    end
    
    
    
    
      
    
    
    
end
