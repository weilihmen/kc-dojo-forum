class ChangeStatusInFriendshipsDefault < ActiveRecord::Migration[5.1]
  def change
  	change_column :friendships, :status, :string, default: "pending"
  end
end
