class Admin::CategoriesController < Admin::BaseController
	def index
  	@categories = Category.all
	  if params[:id]
	    @category = Category.find(params[:id])
	  else
	    @category = Category.new
	  end
  end

  def update
	  @category = Category.find(params[:id])
	  if @category.update(category_params)
	    redirect_to admin_categories_path
	    flash[:notice] = "成功更新"
	  else
	    @categories = Category.all
	    render :index
	  end
	end

  def create
	  @category = Category.new(category_params)
	  if @category.save
	    flash[:notice] = "成功創建"
	    redirect_to admin_categories_path
	  else
	    @categories = Category.all
	    render :index
	  end
  end

   def destroy
    @category = Category.find(params[:id])
    if @category.posts.length == 0
	    @category.destroy
	    flash[:alert] = "成功刪除"
	    redirect_to admin_categories_path
	  else
	  	flash[:alert] = "刪除失敗(分類仍有文章)"
	  	redirect_to admin_categories_path
	  end
  end

  private
  def category_params
  	params.require(:category).permit(:name)
	end
end
