class PostsController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:index]
  before_action :set_post, only: [:edit, :show, :update, :destroy]
  before_action :auth_user, only: [:edit, :update, :destroy]

	def index
		@posts=Post.all
	end

	def new
		@post=Post.new
		session[:return_to] ||= request.referer
		#https://stackoverflow.com/questions/2139996/how-to-redirect-to-previous-page-in-ruby-on-rails
	end

  def edit
    session[:return_to] ||= request.referer
  end

  def show

  end

	def create
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.save
      flash[:notice] = "新增成功"
      redirect_to session.delete(:return_to)
    else
      flash.now[:alert] = "新增失敗"
      render :new
    end
  end

	def update
    if @post.update(post_params)
      flash[:notice] = "更新成功"
      redirect_to session.delete(:return_to)
    else
      flash.now[:alert] = "更新失敗"
      render :edit
    end
  end

  def destroy
    if @post.destroy
      flash[:notice] = "刪除成功"
      redirect_back(fallback_location: root_path)
    else
      flash.now[:alert] = "刪除失敗"
    end
	end

  private

  def post_params
    params.require(:post).permit(:title, :content, :image)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def auth_user
    @user = @post.user
    if @user != current_user
      redirect_back fallback_location: root_path, alert: "你沒有權限喔！"
    end
  end

end
