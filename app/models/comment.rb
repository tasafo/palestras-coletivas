class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :body

  embedded_in :commentable, polymorphic: true
  embeds_many :comments, as: :commentable
  belongs_to :user, index: true

  validates_presence_of :body

  scope :with_user, -> { includes(:user) }

  def comment_on(commentable: nil, user: nil, body: '')
    self.user = user
    self.commentable = commentable
    self.body = body
    save
    self
  end

  def commented_by?(user)
    self.user == user
  end
end
