class Group
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :gravatar_url, type: String
  field :name, type: String
  slug :name
  field :tags, type: String
  field :thumbnail_url, type: String
  field :owner, type: String

  has_and_belongs_to_many :users

  validates_presence_of :name, :tags, :owner
end