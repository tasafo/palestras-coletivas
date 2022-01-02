class Vote
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  belongs_to :schedule, index: true
  belongs_to :user, index: true

  after_create do
    schedule.inc(counter_votes: 1)
  end

  before_destroy do
    schedule.inc(counter_votes: -1)
  end
end
