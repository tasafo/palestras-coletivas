class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :name, type: String
  slug :name
  field :email, type: String
  field :password_hash, type: String

  has_and_belongs_to_many :talks

  attr_reader :password

  validates_presence_of :name

  validates_length_of :name, minimum: 3

  validates_uniqueness_of :name, :email

  validates :email, :format => { :with => /^[^@][\w.-]+@[\w.-]+[.][a-z]{2,4}$/i }

  validates_presence_of :password, :if => :require_password?

  validates_confirmation_of :password, :if => :require_password?

  after_save :erase_password

  def password=(password)
    self.password_hash = PasswordEncryptor.encrypt(password.to_s)
    @validate_password = true
    @password = password
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