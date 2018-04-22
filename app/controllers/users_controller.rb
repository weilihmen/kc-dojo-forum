class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :auth_user, only: [:edit, :update]

	def show

	end
  def edit
    session[:return_to] ||= request.referer
  end
	def update
    if @user.update(user_params)
      flash[:notice] = "更新成功"
      redirect_to session.delete(:return_to)
    else
      flash.now[:alert] = "更新失敗"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :intro, :avatar, :birthday)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def auth_user
    if @user != current_user
      redirect_back fallback_location: root_path, alert: "你沒有權限喔！"
    end
  end

end
