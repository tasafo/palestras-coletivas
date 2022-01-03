class Schedule
  include Mongoid::Document
  include Mongoid::Timestamps

  field :day, type: Integer
  field :time, type: String
  field :description, type: String
  field :counter_votes, type: Integer, default: 0
  field :was_presented, type: Boolean, default: false

  belongs_to :event, index: true
  belongs_to :activity, optional: true, index: true
  belongs_to :talk, optional: true, index: true
  has_many :votes

  validates_presence_of :day, :time, :description
  validates_format_of :time, with: /\A(2[0-3]|1[0-9]|0[0-9]|[^0-9][0-9]):([0-5][0-9]|[0-9])\z/
  validates_uniqueness_of :talk, scope: :event, if: :talk?
  validates_length_of :description, maximum: 50

  scope :presenteds, -> { where(was_presented: true) }
  scope :with_talk, -> { includes(:talk) }
  scope :with_event, -> { includes(:event) }
  scope :with_relations, -> { includes(:event, :talk, :votes) }

  after_create do
    presentation_events_inc(talk, 1) if talk? && was_presented
  end

  after_update do
    if talk?
      if talk_id_changed?
        if talk_id_was && was_presented
          old_talk = Talk.find(talk_id_was)
          presentation_events_inc(old_talk, -1)
        end
      elsif was_presented_changed?
        presentation_events_inc(talk, was_presented ? 1 : -1)
      end
    end
  end

  before_destroy do
    presentation_events_inc(talk, -1) if talk? && was_presented
  end

  def presentation_events_inc(talky, inc)
    talky.users.each do |user|
      user.inc(counter_presentation_events: inc)
    end
    talky.inc(counter_presentation_events: inc)
  end

  def find_vote(user)
    votes.find_by(user: user)
  end

  def show_time
    if event&.accepts_submissions && talk_id
      ''
    else
      time
    end
  end
end
