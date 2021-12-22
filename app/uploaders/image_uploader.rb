class ImageUploader < Uploader
  if ENV['CLOUDINARY_URL'].present?
    cloudinary_transformation transformation: [
      { width: 1920, height: 1080, crop: :limit }
    ]
  end
end
