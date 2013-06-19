class Rating
  include Mongoid::Document
  embedded_in :rateable, :polymorphic => true
  belongs_to :user

  field :rank, :type => Float
  attr_accessible :rank, :user
end