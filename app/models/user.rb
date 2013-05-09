class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include UpdateCounter

  field :name, type: String
  slug :name
  field :email, type: String
  field :password_hash, type: String
  field :auth_token, type: String
  field :password_reset_token, type: String
  field :password_reset_sent_at, type: DateTime
  field :counter_organizing_events, type: Integer, default: 0
  field :counter_presentation_events, type: Integer, default: 0
  field :counter_enrollment_events, type: Integer, default: 0
  field :counter_participation_events, type: Integer, default: 0
  field :counter_public_talks, type: Integer, default: 0

  has_and_belongs_to_many :talks, :inverse_of => :talks

  has_and_belongs_to_many :watched_talks, :class_name => "Talk", :inverse_of => :watched_user

  has_and_belongs_to_many :groups

  has_and_belongs_to_many :events

  has_many :enrollments

  attr_reader :password

  validates_presence_of :name

  validates_length_of :name, minimum: 3

  validates_uniqueness_of :name, :email

  validates :email, :format => { :with => /^[^@][\w.-]+@[\w.-]+[.][a-z]{2,4}$/i }

  validates_presence_of :password, :if => :require_password?

  validates_confirmation_of :password, :if => :require_password?

  after_save :erase_password

  before_create { generate_token(:auth_token) }

  scope :by_name, order_by(:name => :asc)

  scope :organizers, lambda { |user| not_in(:_id => user.id.to_s).order_by(:name => :asc) }

  scope :organizing_events, where(:counter_organizing_events.gt => 0).order_by(:counter_organizing_events => :desc, :name => :asc).limit(5)

  scope :presentation_events, where(:counter_presentation_events.gt => 0).order_by(:counter_presentation_events => :desc, :name => :asc).limit(5)

  scope :participation_events, where(:counter_participation_events.gt => 0).order_by(:counter_participation_events => :desc, :name => :asc).limit(5)

  scope :public_talks, where(:counter_public_talks.gt => 0).order_by(:counter_public_talks => :desc, :name => :asc).limit(5)

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
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.where(column => self[column]).exists?
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def watch_talk! talk
    return if watched_talk? talk
    self.watched_talks << talk
  end

  def unwatch_talk! talk
    self.watched_talks.delete talk
  end

  def watched_talk? talk
    self.watched_talks.include? talk
  end

  def self.list_users(owner)
    User.not_in(:_id => owner.id.to_s).order_by(:name => :asc)
  end

private
  def erase_password
    @password = nil
    @password_confirmation = nil
    @validate_password = false
  end

  def require_password?
    new_record? || @validate_password
  end
end