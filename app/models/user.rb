class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include UpdateCounter

  field :name, type: String
  field :username, type: String
  field :email, type: String
  field :password_hash, type: String
  field :auth_token, type: String
  field :password_reset_token, type: String
  field :password_reset_sent_at, type: DateTime
  field :counter_watched_talks, type: Integer, default: 0
  field :counter_organizing_events, type: Integer, default: 0
  field :counter_presentation_events, type: Integer, default: 0
  field :counter_enrollment_events, type: Integer, default: 0
  field :counter_participation_events, type: Integer, default: 0
  field :counter_public_talks, type: Integer, default: 0
  field :gravatar_photo, type: String

  mount_uploader :avatar, AvatarUploader

  has_and_belongs_to_many :talks, inverse_of: :talks,
                                  dependent: :restrict_with_error
  has_and_belongs_to_many :watched_talks, class_name: 'Talk',
                                          inverse_of: :watched_user
  has_and_belongs_to_many :events, inverse_of: :users,
                                   dependent: :restrict_with_error
  has_many :enrollments, dependent: :restrict_with_error
  has_many :votes
  has_many :owner_events, class_name: 'User', inverse_of: :owner
  has_many :owner_talks, class_name: 'User', inverse_of: :owner

  slug :name

  attr_reader :password

  validates_presence_of :name, :username
  validates_length_of :name, minimum: 3
  validates_uniqueness_of :email, :username
  validates_format_of :email, with: /\A[^@][\w.-]+@[\w.-]+[.][a-z]{2,4}\z/
  validates_format_of :username, with: /\A@[a-z]\w{2}\w+\z/
  validates_presence_of :password, if: :require_password?
  validates_confirmation_of :password, if: :require_password?

  index({ email: 1 }, { unique: true, background: true })
  index({ username: 1 }, { unique: true, background: true })

  after_save :erase_password
  before_create { generate_token(:auth_token) }
  before_save :update_thumbnail
  before_validation :check_username

  scope :by_name, -> { asc(:_slugs) }
  scope :with_relations, -> { includes(:talks, :events) }

  def oid
    _id.to_s
  end

  def check_username
    self.username = '@' << username if !username.blank? && username[0] != '@'
  end

  def show_name
    until_two_names(name) unless name.blank?
  end

  def password=(password)
    if password.blank?
      @validate_password = false
    else
      self.password_hash = PasswordEncryptor.encrypt(password.to_s)
      @validate_password = true
      @password = password
    end
  end

  def generate_token(column)
    self[column] = SecureRandom.urlsafe_base64 while User.where(column => self[column]).exists?
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.now
    save!
    UserMailer.password_reset(id.to_s).deliver_later
  end

  def arrived_at(event)
    enrollment = if enrolled_at? event
                   Enrollment.find_by user: self, event: event
                 else
                   enroll_at event
                 end

    enrollment.present = true

    EnrollmentDecorator.new(enrollment, 'present').update
  end

  def enrolled_at?(event)
    enrollment = Enrollment.find_by(user: self, event: event)

    !enrollment.nil?
  end

  def enroll_at(event)
    enrollment = Enrollment.new(user: self, event: event, active: true)

    EnrollmentDecorator.new(enrollment, 'active').create
  end

  def present_at?(event)
    enrollment = Enrollment.find_by(user: self, event: event)

    enrollment.nil? ? false : enrollment.present
  end

  def watch_talk!(talk)
    return if watched_talk? talk

    watched_talks << talk

    set_counter :watched_talks, :inc
  end

  def unwatch_talk!(talk)
    watched_talks.delete talk

    set_counter :watched_talks, :dec
  end

  def watched_talk?(talk)
    watched_talks.include? talk
  end

  def thumbnail
    if avatar?
      avatar.url
    elsif gravatar_photo?
      gravatar_photo
    else
      'without_avatar.jpg'
    end
  end

  private

  def until_two_names(name)
    name_array = name.split
    name_size = name_array.size
    name_one = name_array[0]

    if name_size > 1
      "#{name_one} #{name_array[name_size - 1]}".titleize
    else
      name_one.titleize
    end
  end

  def erase_password
    @password = nil
    @password_confirmation = nil
    @validate_password = false
  end

  def require_password?
    new_record? || @validate_password
  end

  def update_thumbnail
    self.gravatar_photo = Gravatar.new(email).fields.thumbnail_url
  end
end
