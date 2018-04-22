class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  mount_uploader :avatar, PhotoUploader
  validates_presence_of(:name)
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post
end
