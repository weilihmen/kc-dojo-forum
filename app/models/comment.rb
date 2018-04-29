class Comment < ApplicationRecord
	validates_presence_of(:content)
	belongs_to :post, counter_cache: true
	belongs_to :user
	after_create :touch_post

	def touch_post
		self.post.update(last_comment_at: self.created_at)
	end
end
