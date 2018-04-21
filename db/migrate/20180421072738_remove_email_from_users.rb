class RemoveEmailFromUsers < ActiveRecord::Migration[5.1]
	#先把email刪掉，不然進devise會出錯
  def change
    remove_column :users, :email, :string
  end
end
