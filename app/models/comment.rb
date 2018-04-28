class Comment < ApplicationRecord
	validates_presence_of(:content)
	belongs_to :post, counter_cache: true
	belongs_to :user
end
