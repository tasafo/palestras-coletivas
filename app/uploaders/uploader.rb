#:nodoc:
class Uploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave if ENV['CLOUDINARY_URL'].present?

  process convert: 'jpg' if ENV['CLOUDINARY_URL'].present?

  def extension_allowlist
    %w[jpg jpeg png]
  end

  def store_dir
    "uploads/#{model.class.name.pluralize.downcase}/#{model.id}"
  end
end
