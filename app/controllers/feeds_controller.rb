class FeedsController < ApplicationController
	def index
		@most_comment_posts=Post.joins(:comments).group("posts.id").order("count(posts.id) DESC").limit(10)
		@most_comment_users=User.joins(:comments).group("users.id").order("count(users.id) DESC").limit(10)
	end
end
