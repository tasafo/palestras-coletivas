class Schedule
  include Mongoid::Document
  include Mongoid::Timestamps
  include UpdateCounter

  field :day, type: Integer
  field :time, type: String
  field :environment, type: String
  field :counter_votes, type: Integer, default: 0

  belongs_to :event
  belongs_to :activity
  belongs_to :talk
  has_many :votes

  validates_presence_of :day, :time, :event, :activity
  validates_format_of :time,
    with: /\A(2[0-3]|1[0-9]|0[0-9]|[^0-9][0-9]):([0-5][0-9]|[0-9])\z/

  scope :by_day, lambda {
    |day| where(day: day).asc(:time).desc(:counter_votes)
  }

  def find_vote(user)
    self.votes.find_by(user: user) ? true : false
  end
end