class AddAccessToPosts < ActiveRecord::Migration[5.1]
  def change
  	add_column :posts, :accessible, :string, default: "all"
  end
end
