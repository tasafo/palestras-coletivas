class Talk
  include Mongoid::Document
  include Mongoid::FullTextSearch
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :presentation_url, type: String
  field :title, type: String
  slug :title
  field :description, type: String
  field :tags, type: String
  field :thumbnail, type: String
  field :code, type: String
  field :to_public, type: Boolean, :default => false
  field :owner, type: String

  has_and_belongs_to_many :users

  validates_presence_of :title, :description, :tags, :users

  fulltext_search_in :title, :tags,
    :index_name => 'fulltext_index_title_tags',
    :filters => {
      :published => lambda { |talk| talk.to_public }
    }
end