class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Geocoder::Model::Mongoid
  include Mongoid::Attributes::Dynamic
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
  field :block_presence, type: Boolean, default: false
  field :workload, type: Integer, default: 0
  field :online, type: Boolean, default: false

  mount_uploader :image, ImageUploader

  embeds_many :comments, as: :commentable
  embeds_many :ratings, as: :rateable
  has_and_belongs_to_many :users, inverse_of: :events, index: true,
                                  before_remove: :organizing_events_dec,
                                  after_add: :organizing_events_inc
  has_many :schedules, dependent: :restrict_with_error
  has_many :enrollments, dependent: :restrict_with_error
  belongs_to :owner, class_name: 'User', index: true

  validates_presence_of :name, :tags, :start_date, :end_date, :deadline_date_enrollment
  validates_length_of :name, maximum: 60
  validates_length_of :description, maximum: 2000
  validates_length_of :tags, maximum: 60
  validates_numericality_of :stocking, greater_than_or_equal_to: 0
  validates_numericality_of :workload, greater_than_or_equal_to: 0

  slug :name do |doc|
    doc.name.delete('#').to_url
  end

  index({ name: 'text', tags: 'text' }, { background: true })

  scope :publics, -> { where(to_public: true) }
  scope :upcoming, -> { publics.order(start_date: :desc, name: :asc).limit(5) }
  scope :with_relations, -> { includes(:users, :schedules, :enrollments) }

  geocoded_by :address
  after_validation :geocode, if: ->(obj) { !obj.online? }

  before_destroy do
    users_organizing_events_inc(-1)
  end

  def organizing_events_dec(user)
    user_organizing_events_inc(user, -1)
  end

  def organizing_events_inc(user)
    user_organizing_events_inc(user, 1)
  end

  def users_organizing_events_inc(inc)
    users.each { |user| user_organizing_events_inc(user, inc) }
  end

  def user_organizing_events_inc(user, inc)
    user.inc(counter_organizing_events: inc)
  end

  def address
    EventPolicy.new(self).address
  end

  def location
    online? ? 'online' : place
  end

  def image_path
    Utility.https(image.url)
  end

  def long_date
    date_of = I18n.t('titles.events.date.of')
    fields = {
      start_date: start_date, end_date: end_date, date_of: date_of,
      date_to: I18n.t('titles.events.date.to'), date_format: "%B #{date_of} %Y",
      day_one: Utility.zero_fill(start_date.day),
      day_two: Utility.zero_fill(end_date.day)
    }

    FullDate.new(**fields).convert
  end

  def first_time
    event_schedules = schedules&.order(time: :asc)&.limit(1)

    return '00:00' unless event_schedules

    time = event_schedules.first.time.split(':')

    format("#{time[0]}:%02d", (time[1].to_i + 1).to_s)
  end

  def destroy_image
    image_file = image.file

    ImageFile.remove(image_file) if image_file
  end

  def refresh(attributes)
    attributes.each { |key, value| send("#{key}=", value) }
  end

  def address_from_ip(remote_ip)
    result = Geocoder.search(remote_ip).first

    return unless result

    self.city = result.city
    self.state = result.state
    self.country = result.country
  end
end
