class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy, :like]
  before_action :correct_user,   only: :destroy
  
  
  
  def like
    post=Micropost.find(params[:id])
    #@likes = Like.where(:micropost_id => params[:id])
    #@likers = @likes.find_liker.paginate(page: params[:page])
    likers_ids="SELECT user_id FROM likes WHERE micropost_id= ?"
    @likers= User.where("id IN ( #{likers_ids})",post.id).paginate(page: params[:page])
    render 'show_likes'
  end
  
  def unlike(user)
  end


  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items=current_user.feed.paginate(page: params[:page])
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end

  private
  
    def correct_user
        @micropost = current_user.microposts.find_by(id: params[:id])
        redirect_to root_url if @micropost.nil?
    end

    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end
end