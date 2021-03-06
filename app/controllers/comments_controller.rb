class CommentsController < ApplicationController
  before_action :set_comment, only: [:destroy, :edit, :update]
  before_action :auth_user, only: [:destroy, :edit, :update]

	def create
    @post = Post.find(params[:post_id])
    @comment = Comment.new(comment_params)
    @comment.post = @post
    @comment.user = current_user
    if @comment.save
      flash[:notice] = "回覆成功"
      redirect_to post_path(@post)
    else
      redirect_to request.referrer, alert: "回覆失敗"
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
  end

  def edit
  	@post = Post.find(params[:post_id])
  end

  def update
  	if @comment.update(comment_params)
      
    else
      redirect_to post_path(Post.find(params[:post_id])), alert: "更新失敗"
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def auth_user
    @user = @comment.user
    if @user != current_user
      redirect_back fallback_location: root_path, alert: "你沒有權限喔！"
    end
  end

end
