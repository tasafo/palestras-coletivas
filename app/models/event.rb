class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Geocoder::Model::Mongoid
  include Mongoid::Attributes::Dynamic
  include UpdateCounter
  include Commentable
  include Rateable

  field :name, type: String
  field :edition, type: String
  field :description, type: String
  field :stocking, type: Integer, default: 0
  field :tags, type: String
  field :start_date, type: Date
  field :end_date, type: Date
  field :deadline_date_enrollment, type: Date
  field :to_public, type: Boolean, default: false
  field :rating, type: Fixnum, default: 0
  field :place, type: String
  field :street, type: String
  field :district, type: String
  field :city, type: String
  field :state, type: String
  field :country, type: String
  field :coordinates, type: Array
  field :counter_registered_users, type: Integer, default: 0
  field :counter_present_users, type: Integer, default: 0
  field :accepts_submissions, type: Boolean, default: false

  embeds_many :comments, as: :commentable
  embeds_many :ratings, as: :rateable
  has_and_belongs_to_many :users, inverse_of: :events
  has_many :schedules
  has_many :enrollments
  belongs_to :owner, class_name: "User", inverse_of: :owner_events

  validates_presence_of :name, :edition, :tags, :start_date, :end_date, :deadline_date_enrollment, :place, :street, :district, :city, :state, :country, :owner
  validates_length_of :description, maximum: 2000
  validates_numericality_of :stocking, greater_than_or_equal_to: 0

  slug :name, :edition
end
