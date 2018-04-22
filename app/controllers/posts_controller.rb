class PostsController < ApplicationController
	def index
		@posts=Post.all
	end

	def new
		@post=Post.new
		session[:return_to] ||= request.referer
		#https://stackoverflow.com/questions/2139996/how-to-redirect-to-previous-page-in-ruby-on-rails
	end

  def edit
    @post=Post.find(params[:id])
    session[:return_to] ||= request.referer
  end

  def show
    @post=Post.find(params[:id])
  end

	def create
    @post = Post.new(post_params)
    if @post.save
      flash[:notice] = "新增成功"
      redirect_to session.delete(:return_to)
    else
      flash.now[:alert] = "新增失敗"
      render :new
    end
  end

	def update
    @post=Post.find(params[:id])
    if @post.update(post_params)
      flash[:notice] = "更新成功"
      redirect_to session.delete(:return_to)
    else
      flash.now[:alert] = "更新失敗"
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
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

end
