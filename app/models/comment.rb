class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :body

  embedded_in :commentable, :polymorphic => true
  belongs_to :user

  validates_presence_of :user, :body

  def comment_on!(commentable: nil, user: nil, body: "")
    self.user = user
    self.commentable = commentable
    self.body = body
    save
    self
  end
end