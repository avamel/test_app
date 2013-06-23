class Article < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :comments, :as => :commentable, :dependent => :destroy
  attr_accessible :content, :published_on, :title, :user_ids, :author_id


  validates :title, :content, :published_on, presence: true


  default_scope order: 'articles.published_on ASC'
  default_scope order: 'articles.created_at ASC'
end
