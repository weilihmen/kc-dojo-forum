class Admin::UsersController < Admin::BaseController
	def index
		@q =  User.all.order(id: :desc).search(params[:q])
    @users = @q.result(distinct: true).paginate(:page => params[:page], :per_page => 20)
	end
	def auth
		@user = User.find(params[:user_id])
		@user.update(role: "admin")
		flash[:notice] = "更動成功"
		redirect_to admin_users_path
	end
	def unauth
		@user = User.find(params[:user_id])
		@user.update(role: "normal")
		flash[:notice] = "更動成功"
		redirect_to admin_users_path
	end
end
