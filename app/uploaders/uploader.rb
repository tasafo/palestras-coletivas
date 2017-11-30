class Uploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave if ENV['CLOUDINARY_URL'].present?

  process convert: 'jpg' if ENV['CLOUDINARY_URL'].present?

  def extension_whitelist
    %w(jpg jpeg gif png)
  end
end
