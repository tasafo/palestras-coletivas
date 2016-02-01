#:nodoc:
class Vote
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  belongs_to :schedule
  belongs_to :user
end
