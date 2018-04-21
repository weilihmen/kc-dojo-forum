class CreateJoinTable < ActiveRecord::Migration[5.1]
  def change
    create_join_table :posts, :categories do |t|
      # t.index [:post_id, :category_id]
      t.index [:category_id, :post_id], unique: true
    end
  end
end
