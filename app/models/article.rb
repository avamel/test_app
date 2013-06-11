class Article < ActiveRecord::Base
  belongs_to :user
  attr_accessible :content, :published_on, :title

  validates :user_id, :title, :content, presence: true

  default_scope order: 'articles.published_on DESC'
end
