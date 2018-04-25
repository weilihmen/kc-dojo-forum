class AddIgnoreToFriendships < ActiveRecord::Migration[5.1]
  def change
  	add_column :friendships, :ignore, :boolean, default: false
  end
end
