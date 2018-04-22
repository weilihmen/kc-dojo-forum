class Post < ApplicationRecord
	mount_uploader :image, PhotoUploader
	has_and_belongs_to_many :categories
	belongs_to :user
	has_many :comments, dependent: :destroy
end
