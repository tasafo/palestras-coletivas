class Schedule
  include Mongoid::Document
  include Mongoid::Timestamps

  field :day, type: Integer
  field :time, type: String
  field :environment, type: String

  belongs_to :event

  belongs_to :activity

  belongs_to :talk

  validates_presence_of :day, :time, :event, :activity

  scope :by_day, lambda { |day| where(:day => day).order_by(:time => :asc) }
end