class RemoveCategoryIdFromPosts < ActiveRecord::Migration[5.1]
  def change
    remove_column :posts, :category_id, :string
  end
end
