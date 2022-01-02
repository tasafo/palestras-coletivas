class Rating
  include Mongoid::Document

  embedded_in :rateable, polymorphic: true
  belongs_to :user, index: true

  field :rank, type: Float
end
