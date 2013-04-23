class Group
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include UpdateCounter

  field :gravatar_url, type: String
  field :name, type: String
  slug :name
  field :tags, type: String
  field :thumbnail_url, type: String
  field :owner, type: String
  field :counter_participation_events, type: Integer, default: 0

  has_and_belongs_to_many :users

  has_and_belongs_to_many :events

  validates_presence_of :name, :tags, :owner

  scope :participation_events, where(:counter_participation_events.gt => 0).order_by(:counter_participation_events => :desc, :name => :asc).limit(5)
end