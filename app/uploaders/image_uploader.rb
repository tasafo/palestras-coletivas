#:nodoc:
class ImageUploader < Uploader
  if ENV['CLOUDINARY_URL'].present?
    cloudinary_transformation transformation: [
      { width: 1024, height: 768, crop: :limit }
    ]
  end
end
