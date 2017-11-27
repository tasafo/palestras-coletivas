class ImageUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave unless Rails.env.test?

  process convert: 'jpg' unless Rails.env.test?

  cloudinary_transformation transformation: [
    { width: 1024, height: 768, crop: :limit }
  ] unless Rails.env.test?

  def extension_whitelist
    %w(jpg jpeg gif png)
  end
end
