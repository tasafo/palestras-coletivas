class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :name, type: String
  slug :name
  field :email, type: String
  field :password_hash, type: String
  field :auth_token, type: String
  field :password_reset_token, type: String
  field :password_reset_sent_at, type: DateTime
  field :counter_organizing_events, type: Integer, default: 0
  field :counter_talks_events, type: Integer, default: 0
  field :counter_participation_events, type: Integer, default: 0

  has_and_belongs_to_many :talks

  has_and_belongs_to_many :groups

  has_and_belongs_to_many :events

  attr_reader :password

  validates_presence_of :name

  validates_length_of :name, minimum: 3

  validates_uniqueness_of :name, :email

  validates :email, :format => { :with => /^[^@][\w.-]+@[\w.-]+[.][a-z]{2,4}$/i }

  validates_presence_of :password, :if => :require_password?

  validates_confirmation_of :password, :if => :require_password?

  after_save :erase_password

  before_create { generate_token(:auth_token) }

  scope :organizers, lambda { |user| not_in(:_id => user.id.to_s).order_by(:name => :asc) }

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

  def set_counter(field, operation)
    field = "counter_#{field}"

    if operation == :inc
      self[field] = self[field] + 1
    elsif operation == :dec
      self[field] = self[field] - 1 if self[field] > 0
    end

    self.save
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