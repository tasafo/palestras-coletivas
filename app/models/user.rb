class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include UpdateCounter

  field :name, type: String
  slug :name
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

  has_and_belongs_to_many :talks, :inverse_of => :talks

  has_and_belongs_to_many :watched_talks, :class_name => "Talk", :inverse_of => :watched_user

  has_and_belongs_to_many :events

  has_many :enrollments

  has_many :votes

  attr_reader :password

  validates_presence_of :name, :username

  validates_length_of :name, minimum: 3

  validates_uniqueness_of :name, :email, :username

  validates_format_of :email, with: /\A[^@][\w.-]+@[\w.-]+[.][a-z]{2,4}\z/

  validates :username, :format => { :with => /^@[a-z]\w{2}\w+$/ }

  validates_presence_of :password, :if => :require_password?

  validates_confirmation_of :password, :if => :require_password?

  after_save :erase_password

  before_create { generate_token(:auth_token) }

  scope :by_name, -> { order_by(:_slugs => :asc) }

  scope :without_the_owner, lambda { |user| not_in(:_id => user.id.to_s).by_name }

  scope :top_talk_watchers, -> { where(:counter_watched_talks.gt => 0).order_by(:counter_watched_talks => :desc, :_slugs => :asc).limit(5) }

  scope :organizing_events, -> { where(:counter_organizing_events.gt => 0).order_by(:counter_organizing_events => :desc, :_slugs => :asc).limit(5) }

  scope :presentation_events, -> { where(:counter_presentation_events.gt => 0).order_by(:counter_presentation_events => :desc, :_slugs => :asc).limit(5) }

  scope :participation_events, -> { where(:counter_participation_events.gt => 0).order_by(:counter_participation_events => :desc, :_slugs => :asc).limit(5) }

  scope :public_talks, -> { where(:counter_public_talks.gt => 0).order_by(:counter_public_talks => :desc, :_slugs => :asc).limit(5) }

  def show_name
    return until_two_names(name) unless name.blank?
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
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.where(column => self[column]).exists?
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver_now
  end

  def arrived_at event
    if enrolled_at? event
      enrollment = Enrollment.find_by user: self, event: event
    else
      enrollment = enroll_at event
    end

    enrollment.present = true
    enrollment.save
  end

  def enrolled_at? event
    enrollment = Enrollment.find_by user: self, event: event

    enrollment.nil? ? false : true
  end

  def enroll_at event
    Enrollment.create(user: self, event: event, active: true)
  end

  def present_at? event
    enrollment = Enrollment.find_by user: self, event: event

    if enrollment.nil?
      return false
    else
      return enrollment.present
    end
  end

  def watch_talk! talk
    return if watched_talk? talk
    self.watched_talks << talk
    set_counter :watched_talks, :inc
  end

  def unwatch_talk! talk
    self.watched_talks.delete talk
    set_counter :watched_talks, :dec
  end

  def watched_talk? talk
    self.watched_talks.include? talk
  end

  private
    def until_two_names(name)
      nameArray = name.split(" ")
      return nameArray.size > 1 ? "#{nameArray[0]} #{nameArray[nameArray.size-1]}".titleize : nameArray[0].titleize
    end

    def erase_password
      @password = nil
      @password_confirmation = nil
      @validate_password = false
    end

    def require_password?
      new_record? || @validate_password
    end
end
