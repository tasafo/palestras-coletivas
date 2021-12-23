class CloudinaryReady
  def self.up?
    rails_env = Rails.env

    rails_env.production? || (rails_env.development? && ENV['CLOUDINARY_URL'].present?)
  end
end
