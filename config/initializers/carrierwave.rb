if Rails.env.test? || !ENV['CLOUDINARY_URL'].present?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
end