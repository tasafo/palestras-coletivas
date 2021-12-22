class PasswordEncryptor
  def self.encryptor
    BCrypt::Password
  end

  def self.encrypt(password)
    encryptor.create(password)
  end

  def self.valid?(password_hash, password)
    encryptor.new(password_hash) == password
  end
end
