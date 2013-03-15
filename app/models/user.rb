class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :email, type: String
  field :password_hash, type: String

  has_many :talks

  attr_reader :password

  validates_presence_of :name

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
      @validate_password = true
    end

    def require_password?
      new_record? || @validate_password
    end
end