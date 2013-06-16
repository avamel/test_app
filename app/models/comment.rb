class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :comments, :as => :commentable, :dependent => :destroy
  attr_accessible :content
  validates :user_id, :content, presence: true

  def article
    return @article if defined?(@article)
    @article = commentable.is_a?(Article) ? commentable : commentable.article
  end
end
