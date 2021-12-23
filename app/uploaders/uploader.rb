class Uploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave if CloudinaryReady.up?

  process convert: 'jpg' if CloudinaryReady.up?

  def extension_allowlist
    %w[jpg jpeg png]
  end

  def store_dir
    folder = Rails.env.test? ? 'tmp' : 'uploads'

    Rails.root.join('public', folder, model.class.name.pluralize.downcase, model.id)
  end
end
