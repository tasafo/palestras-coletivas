class Talk
  include Mongoid::Document
  include Mongoid::Search
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Mongoid::Attributes::Dynamic
  include UpdateCounter
  include Commentable

  field :presentation_url, type: String
  field :title, type: String
  field :description, type: String
  field :tags, type: String
  field :thumbnail, type: String
  field :code, type: String
  field :to_public, type: Boolean, default: false
  field :video_link, type: String
  field :counter_presentation_events, type: Integer, default: 0

  has_and_belongs_to_many :users, inverse_of: :talks
  has_and_belongs_to_many :watched_users, class_name: "User", inverse_of: :watched_talk
  has_many :schedules
  embeds_many :external_events
  embeds_many :comments, as: :commentable
  belongs_to :owner, class_name: "User", inverse_of: :owner_talks

  slug :title
  search_in :title, :tags

  validates_presence_of :title, :description, :tags, :owner
  validates_uniqueness_of :presentation_url, :if => :has_url?
  validates_length_of :title, maximum: 100
  validates_length_of :description, maximum: 2000

  index({presentation_url: 1}, {background: true})

  def has_url?
    !presentation_url.blank?
  end
end
