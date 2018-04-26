class FriendshipsController < ApplicationController

  def create
    #只可以在其他user的個人頁面上送出好友邀請
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
    if params[:ajax_source] == "tab"
      #在自己個人檔案的friend分頁上刪除好友(ajax)
      @friend=User.find(params[:user_id])
      respond_to do |format|
      format.js { render 'js/tab-js/destroy.js.erb' }
      end
    else
      #可以在其他user的個人頁面上刪除好友
      redirect_back(fallback_location: root_path)
      flash[:notice] = "成功刪除"
    end
  end
  def approve
    friendship = current_user.unapproved_request.where(user_id: params[:user_id])
    friendship.update(status: "approved")
    if params[:ajax_source] == "tab"
      #在自己個人檔案的friend分頁上確認好友邀請(ajax)
      @friend=User.find(params[:user_id])
      respond_to do |format|
      format.js { render 'js/tab-js/approve.js.erb' }
      end
    else
      #可以在其他user的個人頁面上確認好友邀請
      redirect_back(fallback_location: root_path)
      flash[:notice] = "成功回覆"
    end
  end
  def ignore
    friendship = current_user.unapproved_request.where(user_id: params[:user_id])
    friendship.update(:ignore => true)
    if params[:ajax_source] == "tab"
      #在自己個人檔案的friend分頁上隱藏好友邀請(ajax)
      @friend=User.find(params[:user_id])
      respond_to do |format|
      format.js { render 'js/tab-js/destroy.js.erb' }
      end
    else
      #可以在其他user的個人頁面上隱藏好友邀請
      redirect_back(fallback_location: root_path)
      flash[:notice] = "成功刪除"
    end
  end
  def unignore
    #只可以在其他user的個人頁面上取消好友邀請的隱藏
    friendship = current_user.unapproved_request.where(user_id: params[:user_id])
    friendship.update(:ignore => false)
    redirect_back(fallback_location: root_path)
  end
end
