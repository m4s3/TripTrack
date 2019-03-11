class StaticPagesController < ApplicationController
  def home
     if logged_in?
       @micropost = current_user.microposts.build
       @feed_items = current_user.feed.paginate(page: params[:page])
     end
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
  
  def dize
  end
  
  def dizr
  end
  
  def pack
  end
  
  def diza
  end
  
  def rusers
  end
  
  def rposts
  end
  
  def rlikes
  end
  
  def rrel
  end
  
  def rfrie
  end


 
end
