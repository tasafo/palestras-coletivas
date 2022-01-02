class Vote
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  belongs_to :schedule, index: true
  belongs_to :user

  after_create do
    schedule.inc(counter_votes: 1)
  end

  before_destroy do
    schedule.inc(counter_votes: -1)
  end
end
