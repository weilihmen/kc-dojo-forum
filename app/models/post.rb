class Post < ApplicationRecord
	is_impressionable
	mount_uploader :image, PhotoUploader
	has_and_belongs_to_many :categories
	belongs_to :user
	has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  def accessible?(current_user)
  	if self.accessible == "all"
  		return true
  	elsif self.accessible == "friend"
  		if self.user == current_user or self.user.all_friends.include?(current_user)
  			return true
  		else
  			return false
  		end
  	elsif self.accessible == "self"
  		if self.user == current_user
  			return true
  		else
  			return false
  		end
  	else
  		return false
  	end		
  end

end
