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

  has_many :friendships, dependent: :destroy

  #pending=> 送出要求，對方尚未回應 
  has_many :pending_request, -> {where status: "pending"}, class_name:"Friendship"
  has_many :pending_friends, through: :unapproved_request, source: :friend

  #unapproved=> 收到要求，自己尚未回應
  has_many :unapproved_request, -> {where status: "pending"}, class_name:"Friendship", foreign_key:"friend_id"
  has_many :unapproved_friends, through: :unapproved_request, source: :user

  has_many :direct_friendships, -> {where status: "approved"}, class_name:"Friendship"
  has_many :direct_friends, through: :direct_friendships, source: :friend

  has_many :inverse_friendships, -> {where status: "approved"}, class_name:"Friendship", foreign_key:"friend_id"
  has_many :inverse_friends, through: :inverse_friendships, source: :user


  def all_friends #這個有問題
    all_friends = self.direct_friends+self.inverse_friends
    return all_friends
  end
  def admin?
    self.role == "admin"
  end
end
