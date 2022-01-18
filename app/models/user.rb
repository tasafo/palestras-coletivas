class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :name, type: String
  field :username, type: String
  field :email, type: String
  field :password_hash, type: String
  field :auth_token, type: String
  field :password_reset_token, type: String
  field :password_reset_sent_at, type: DateTime
  field :counter_public_talks, type: Integer, default: 0
  field :counter_watched_talks, type: Integer, default: 0
  field :counter_organizing_events, type: Integer, default: 0
  field :counter_presentation_events, type: Integer, default: 0
  field :counter_enrollment_events, type: Integer, default: 0
  field :counter_participation_events, type: Integer, default: 0
  field :gravatar_photo, type: String

  mount_uploader :avatar, AvatarUploader

  has_and_belongs_to_many :talks, inverse_of: :talks, index: true, dependent: :restrict_with_error
  has_and_belongs_to_many :watched_talks, class_name: 'Talk', inverse_of: :watched_user, index: true
  has_and_belongs_to_many :events, inverse_of: :users, index: true, dependent: :restrict_with_error
  has_many :enrollments, dependent: :restrict_with_error
  has_many :votes

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

  scope :with_relations, -> { includes(:talks, :events) }

  after_save do
    @password = nil
    @password_confirmation = nil
    @validate_password = false
  end

  before_create do
    generate_token(:auth_token)
  end

  before_save do
    self.gravatar_photo = Gravatar.new(email).thumbnail_url
  end

  before_validation do
    self.username = '@' << username if !username.blank? && username[0] != '@'
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
    enrollment = enrollments.find_by(event: event)
    enrollment ||= enroll_at(event)
    enrollment.present = true

    EnrollmentDecorator.new(enrollment, 'present').update
  end

  def enroll_at(event)
    enrollment = enrollments.new(event: event, active: true)

    EnrollmentDecorator.new(enrollment, 'active').create
  end

  def present_at?(event)
    enrollment = enrollments.find_by(event: event)

    enrollment ? enrollment.present : false
  end

  def watch_talk(talk)
    return if watched_talk? talk

    watched_talks << talk

    inc(counter_watched_talks: 1)
  end

  def unwatch_talk(talk)
    watched_talks.delete talk

    inc(counter_watched_talks: -1)
  end

  def watched_talk?(talk)
    watched_talks.include? talk
  end

  def thumbnail
    if avatar?
      Utility.https(avatar.url)
    elsif gravatar_photo?
      Utility.https(gravatar_photo)
    end
  end

  def destroy_avatar
    image_file = avatar.file

    ImageFile.remove(image_file) if image_file
  end

  private

  def require_password?
    new_record? || @validate_password
  end
end
