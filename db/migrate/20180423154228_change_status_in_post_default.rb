class ChangeStatusInPostDefault < ActiveRecord::Migration[5.1]
  def change
  	change_column :posts, :status, :string, default: "pending"
  end
end
