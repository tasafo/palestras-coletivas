class Enrollment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :active, type: Boolean, default: true
  field :present, type: Boolean, default: false

  belongs_to :event, index: true
  belongs_to :user, index: true

  validates_uniqueness_of :user, scope: :event

  scope :actives, -> { where(active: true) }
  scope :presents, -> { where(present: true) }
  scope :with_user, -> { includes(:user) }

  after_create do
    counters_inc(user, event, 1)
  end

  after_update do
    counters_inc(user, event, active ? 1 : -1) if active_changed?

    if present_changed?
      counter = present ? 1 : -1
      user.inc(counter_participation_events: counter)
      event.inc(counter_present_users: counter)
    end
  end

  def counters_inc(user, event, inc)
    user.inc(counter_enrollment_events: inc)
    event.inc(counter_registered_users: inc)
  end
end
