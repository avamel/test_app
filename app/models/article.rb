class Article < ActiveRecord::Base
  belongs_to :user
  has_many :comments, :as => :commentable, :dependent => :destroy
  attr_accessible :content, :published_on, :title

  validates :user_id, :title, :content, :published_on, presence: true


  default_scope order: 'articles.published_on ASC'
  default_scope order: 'articles.created_at ASC'
end
