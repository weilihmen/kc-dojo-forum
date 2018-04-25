class FriendshipsController < ApplicationController

	def create
    if Friendship.create(user_id: current_user.id, friend_id: params[:user_id])
      redirect_back(fallback_location: root_path)
      flash[:notice] = "送出邀請"
    else
      redirect_back(fallback_location: root_path)
    end
  end
  def destroy
  	Friendship.where(user_id: params[:user_id], friend_id: current_user.id).destroy_all
  	Friendship.where(user_id: current_user.id, friend_id: params[:user_id]).destroy_all
    redirect_back(fallback_location: root_path)
    flash[:notice] = "成功刪除"
  end
	def approve
		friendship = current_user.unapproved_request.where(user_id: params[:user_id])
		friendship.update(status: "approved")
		redirect_back(fallback_location: root_path)
		flash[:notice] = "成功回覆"
	end
	def ignore
		friendship = current_user.unapproved_request.where(user_id: params[:user_id])
		friendship.update(:ignore => true)
		redirect_back(fallback_location: root_path)
	end
	def unignore
		friendship = current_user.unapproved_request.where(user_id: params[:user_id])
		friendship.update(:ignore => false)
		redirect_back(fallback_location: root_path)
	end
end
