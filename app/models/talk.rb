class Talk
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Mongoid::Attributes::Dynamic
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

  has_and_belongs_to_many :users, inverse_of: :talks, index: true,
                                  before_remove: :public_talks_dec,
                                  after_add: :public_talks_inc
  has_and_belongs_to_many :watched_users, class_name: 'User', inverse_of: :watched_talk, index: true
  has_many :schedules, dependent: :restrict_with_error
  embeds_many :external_events
  embeds_many :comments, as: :commentable
  belongs_to :owner, class_name: 'User', index: true

  slug :title

  validates_presence_of :title, :description, :tags
  validates_uniqueness_of :presentation_url, if: :url?
  validates_length_of :title, maximum: 100
  validates_length_of :tags, maximum: 60
  validates_length_of :description, maximum: 2000

  index({ presentation_url: 1 }, { background: true })
  index({ title: 'text', tags: 'text' }, { background: true })

  scope :publics, -> { where(to_public: true) }
  scope :with_users, -> { includes(:users) }
  scope :with_schedules, -> { includes(:schedules) }

  before_destroy do
    users_public_talks_inc(-1)
  end

  def public_talks_dec(user)
    user_public_talks_inc(user, -1)
  end

  def public_talks_inc(user)
    user_public_talks_inc(user, 1)
  end

  def users_public_talks_inc(inc)
    users.each { |user| user_public_talks_inc(user, inc) }
  end

  def user_public_talks_inc(user, inc)
    user.inc(counter_public_talks: inc) if to_public
  end

  def url?
    !presentation_url.blank?
  end

  def thumbnail_image
    thumbnail.blank? ? 'without_presentation.jpg' : Utility.https(thumbnail)
  end
end
