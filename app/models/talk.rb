class Talk
  include Mongoid::Document
  include Mongoid::FullTextSearch
  include Mongoid::Timestamps
  include Mongoid::Slug
  include UpdateCounter
  include Commentable

  field :presentation_url, type: String
  field :title, type: String
  slug :title
  field :description, type: String
  field :tags, type: String
  field :thumbnail, type: String
  field :code, type: String
  field :to_public, type: Boolean, :default => false
  field :owner, type: String
  field :video_link, type: String
  field :counter_presentation_events, type: Integer, default: 0

  has_and_belongs_to_many :users, :inverse_of => :talks

  has_and_belongs_to_many :watched_users, class_name: "User", :inverse_of => :watched_talk
  
  has_many :schedules

  embeds_many :external_events
  embeds_many :comments, :as => :commentable
  
  validates_presence_of :title, :description, :tags, :users, :owner

  scope :presentation_events, where(:counter_presentation_events.gt => 0).order_by(:counter_presentation_events => :desc, :_slugs => :asc).limit(5)

  fulltext_search_in :title, :tags,
    :index_name => 'fulltext_index_talks',
    :filters => {
      :published => lambda { |talk| talk.to_public }
    }

  def add_authors(owner, others)
    self.owner = owner.id if new_record?

    self.users = nil
    self.users << owner

    if others
      others.each do |author|
        user = User.find(author)
        self.users << [user] if user
      end
    end
  end

  def update_user_counters
    self.users.each do |author|
      user = User.find(author)
      user.counter_public_talks = user.talks.where(:to_public => true).count
      user.save
    end
  end
end