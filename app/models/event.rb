class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Mongoid::FullTextSearch
  include Geocoder::Model::Mongoid

  field :name, type: String
  field :edition, type: String
  slug :name, :edition
  field :description, type: String
  field :stocking, type: Integer, :default => 0
  field :tags, type: String
  field :start_date, type: Date
  field :end_date, type: Date
  field :days, type: Integer
  field :to_public, type: Boolean, :default => false
  field :place, type: String
  field :address, type: String
  field :coordinates, type: Array
  field :owner, type: String
  field :links, type: Hash # {description, url}
  field :environments, type: Hash # {description, order}

  has_and_belongs_to_many :users

  has_and_belongs_to_many :groups

  has_many :schedules

  validates_presence_of :name, :edition, :tags, :start_date, :end_date, :place, :address, :owner

  validates_length_of :description, maximum: 500

  validates_numericality_of :stocking, greater_than_or_equal_to: 0

  geocoded_by :address

  after_validation :geocode, :if => :address_changed?

  before_save :number_of_days

  fulltext_search_in :name, :edition, :tags, :address,
    :index_name => 'fulltext_index_events',
    :filters => {
      :published => lambda { |event| event.to_public }
    }

private
  def number_of_days
    self.days = (self.start_date..self.end_date).to_a.count
  end
end
