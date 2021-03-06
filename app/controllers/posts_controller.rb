class PostsController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:index]
  before_action :set_post, only: [:edit, :show, :update, :destroy, :like, :unlike]
  before_action :auth_user, only: [:edit, :update, :destroy]
  before_action :accessible_user, only: [:show, :edit, :update, :destroy, :like, :unlike]
  before_action :publish_status, only: [:show]
  impressionist :actions=>[:show]

	def index
    #https://stackoverflow.com/questions/14437009/ordering-a-results-set-with-pagination-using-will-paginate
    #https://github.com/activerecord-hackery/ransack
    if current_user
      post_all_ids = []
      Post.all.where(status: "publish", accessible: "all").each { |p| post_all_ids << p.id}
      post_friend_ids = []
      Post.all.where(status: "publish", accessible: "friend").each { |p| post_friend_ids << p.id if p.accessible?(current_user) }
      puts "post_friend_ids #{post_friend_ids}"
      post_self_ids = []
      Post.all.where(status: "publish", accessible: "self").each { |p| post_self_ids << p.id if p.user == current_user }
      puts "post_self_ids #{post_self_ids}"
      posts_ids = post_all_ids + post_friend_ids + post_self_ids 
      posts = Post.where('id in (?)', posts_ids)
      puts "posts #{posts.all}"
      @q = posts.order(id: :desc).search(params[:q])
    else
      @q = Post.all.where(status: "publish", accessible: "all").order(id: :desc).search(params[:q])
    end
    @posts = @q.result(distinct: true).paginate(:page => params[:page], :per_page => 20)
	end

	def new
		@post=Post.new
    @categories=Category.all
		session[:return_to_a] ||= request.referer
		#https://stackoverflow.com/questions/2139996/how-to-redirect-to-previous-page-in-ruby-on-rails
	end

  def edit
    session[:return_to_b] ||= request.referer
  end

  def show
    impressionist(@post)
    @post.update(view_count: @post.impressionist_count(:filter=>:session_hash))
    @comments = @post.comments.order(created_at: :desc).paginate(:page => params[:page], :per_page => 20)
    @comment = Comment.new
    session[:return_to_c] ||= request.referer
  end

	def create
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.save
      flash[:notice] = "新增成功"
      redirect_to session.delete(:return_to_a)
    else
      flash.now[:alert] = "新增失敗"
      render :new
    end
  end

	def update
    if @post.update(post_params)
      flash[:notice] = "更新成功"
      redirect_to session.delete(:return_to_b)
    else
      flash.now[:alert] = "更新失敗"
      render :edit
    end
  end

  def destroy
    if @post.destroy
      flash[:notice] = "刪除成功"
      redirect_to session.delete(:return_to_c)
    else
      flash.now[:alert] = "刪除失敗"
    end
	end

  def like
    @post.likes.create!(user: current_user)
  end

  def unlike
    likes = Like.where(post: @post, user: current_user)
    likes.destroy_all
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :image, :status, :accessible, category_ids: [])
    #https://stackoverflow.com/questions/4425176/in-rails-how-to-handle-multiple-checked-checkboxes-just-split-on-the-or
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

  def publish_status
    if @post.status == "pending"
      redirect_back fallback_location: root_path, alert: "草稿狀態禁止進入"
    end
  end

  def accessible_user
    if @post.accessible?(current_user) == false
      redirect_back fallback_location: root_path, alert: "你沒有權限喔！"
    end
  end

end
