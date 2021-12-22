class Activity
  include Mongoid::Document

  field :type, type: String
  field :description, type: String, localize: true
  field :order, type: Integer

  has_many :schedules, dependent: :restrict_with_error

  validates_presence_of :type, :description, :order
end
