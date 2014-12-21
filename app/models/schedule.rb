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

  validates_format_of :time, with: /\A(2[0-3]|1[0-9]|0[0-9]|[^0-9][0-9]):([0-5][0-9]|[0-9])\z/

  scope :by_day, lambda { |day| where(:day => day).order_by(:time => :asc, :counter_votes => :desc) }

  def update_counter_of_users_talks(old_talk_id, talk_id)
    unless old_talk_id.blank?
      if old_talk_id != talk_id
        old_talk = Talk.find(old_talk_id)

        old_talk.users.each do |user|
          user.set_counter(:presentation_events, :dec)
        end

        old_talk.set_counter(:presentation_events, :dec)
      end
    end

    if talk?
      talk.users.each do |user|
        user.set_counter(:presentation_events, :inc)
      end

      talk.set_counter(:presentation_events, :inc)
    end    
  end

  def find_vote(user)
    self.votes.find_by(:user => user) ? true : false
  end
end