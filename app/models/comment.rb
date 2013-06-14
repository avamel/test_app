class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :article
  attr_accessible :content
  validates :user_id, :article_id, :content, presence: true
end
