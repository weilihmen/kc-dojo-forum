class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.string :status
      t.string :image
      t.string :category_id
      t.string :access

      t.timestamps
    end
  end
end
