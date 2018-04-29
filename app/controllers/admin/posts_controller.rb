class Admin::PostsController < Admin::BaseController
	before_action :set_post, only: [:destroy]
	def index
    @q =  Post.all.order(id: :desc).search(params[:q])
    @posts = @q.result(distinct: true).includes(:user).paginate(:page => params[:page], :per_page => 20)
	end
  def destroy
    if @post.destroy
      flash[:notice] = "刪除成功"
      redirect_to admin_posts_path
    else
      flash.now[:alert] = "刪除失敗"
    end
	end

	private
	def set_post
    @post = Post.find(params[:id])
  end
end
