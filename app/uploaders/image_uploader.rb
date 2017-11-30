class ImageUploader < Uploader
  cloudinary_transformation transformation: [
    { width: 1024, height: 768, crop: :limit }
  ] if ENV['CLOUDINARY_URL'].present?
end
