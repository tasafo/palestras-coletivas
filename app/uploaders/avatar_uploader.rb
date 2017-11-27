class AvatarUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave unless Rails.env.test?

  process convert: 'jpg' unless Rails.env.test?

  cloudinary_transformation transformation: [
    { width: 100, height: 100, crop: :limit }
  ] unless Rails.env.test?

  def extension_whitelist
    %w(jpg jpeg gif png)
  end
end
