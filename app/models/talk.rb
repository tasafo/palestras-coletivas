class Talk
  include Mongoid::Document
  include Mongoid::FullTextSearch
  include Mongoid::Timestamps
  include Mongoid::Slug
  include UpdateCounter

  field :presentation_url, type: String
  field :title, type: String
  slug :title
  field :description, type: String
  field :tags, type: String
  field :thumbnail, type: String
  field :code, type: String
  field :to_public, type: Boolean, :default => false
  field :owner, type: String
  field :counter_presentation_events, type: Integer, default: 0

  has_and_belongs_to_many :users
  
  has_many :schedules
  
  validates_presence_of :title, :description, :tags, :users, :owner

  scope :presentation_events, where(:counter_presentation_events.gt => 0).order_by(:counter_presentation_events => :desc, :title => :asc).limit(5)

  fulltext_search_in :title, :tags,
    :index_name => 'fulltext_index_talks',
    :filters => {
      :published => lambda { |talk| talk.to_public }
    }
end