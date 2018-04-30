class Api::V1::PostsController < ApiController
	before_action :authenticate_user_from_token!
	before_action :authenticate_user!, except: [:index, :login]
  before_action :set_post, only: [:show, :update, :destroy]
  before_action :accessible_user, only: [:show, :update, :destroy]
	
	def index
    if current_user
      @posts = Post.all.where(status: "publish")
    else
      @posts = Post.all.where(status: "publish", accessible: "all")
    end
    render json: {
      data: @posts.map do |p|
        if current_user
          if p.accessible?(current_user)
            {
              title: p.title,
              author: p.user.name,
              created_at: p.created_at.strftime("%Y/%m/%d %H:%M"),
              comments_count: p.comments_count,
              view_count: p.view_count
            }
          end
        else
          {
            title: p.title,
            author: p.user.name,
            created_at: p.created_at.strftime("%Y/%m/%d %H:%M"),
            comments_count: p.comments_count,
            view_count: p.view_count
          }
        end
      end
    }
  end

  def show
    if !@post
      render json: {
        message: "資料錯誤",
        status: 400
      }
    else
      render json: {
	      title: @post.title,
	      author: @post.user.name,
	      content: @post.content
      }
    end
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.save
      render json: {
        message: "建立成功",
        result: @post
      }
    else
      render json: {
        errors: @post.errors
      }
    end
  end

  def update
    if @post.user==current_user && @post.update(post_params)
      render json: {
        message: "更新成功",
        result: @post
      }
    else
      render json: {
        errors: "更新失敗，請確認權限及參數正確"
      }
    end
  end

  def destroy
    if @post.user==current_user && @post.destroy
      render json: {
        message: "刪除成功"
      }
    else
      render json: {
        errors: "刪除失敗，請確認權限及參數正確"
      }
    end
  end

  def login
    if params[:email] && params[:password]
      user = User.find_by_email(params[:email])
    end
    if user && user.valid_password?(params[:password])
      render json: {
        message: "登入成功",
        auth_token: user.authentication_token,
        user_id: user.id}
    else
      render json: { message:  "登入失敗" }, status:  401
    end
  end

  def logout
    current_user.generate_authentication_token
    current_user.save!
    render json: { message:  "登出成功" }
  end
  
  private

  def post_params
    params.permit(:title, :content, :image, :status, category_ids: [])
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def accessible_user
    if @post.accessible?(current_user) == false
      render json: { message:  "你沒有權限喔！" }, status:  401
    end
  end

  def authenticate_user_from_token!
    if params[:auth_token].present?
      user = User.find_by_authentication_token(params[:auth_token])
      sign_in(user, store: false) if user
    end
  end

end
