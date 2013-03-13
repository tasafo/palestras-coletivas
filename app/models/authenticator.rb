class Authenticator
  def self.encryptor
    PasswordEncryptor
  end

  def self.repository
    User
  end

  def self.authenticate(email, password)
    begin
      user = repository.find_by(:email => email)
      return unless user

      user if encryptor.valid?(user.password_hash, password)
    rescue Mongoid::Errors::DocumentNotFound
      return false
    end
  end
end