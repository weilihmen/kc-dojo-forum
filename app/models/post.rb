class Post < ApplicationRecord
	mount_uploader :image, PhotoUploader
	has_and_belongs_to_many :categories
	belongs_to :user
	has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
end
