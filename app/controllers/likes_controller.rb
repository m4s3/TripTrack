class LikesController < ApplicationController
  before_action :logged_in_user
  
  def create
    liker=User.find(params[:user])
    liker.add_like(params[:micro])
    flash.now[:success]="Added like"
    redirect_to request.referrer
  end

end
