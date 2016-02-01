#:nodoc:
class Enrollment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :active, type: Boolean, default: true
  field :present, type: Boolean, default: false

  belongs_to :event
  belongs_to :user

  validates_uniqueness_of :user, scope: :event

  scope :actives, -> { where(active: true) }
  scope :presents, -> { where(present: true) }
end
