class AvatarUploader < Uploader
  cloudinary_transformation transformation: [
    { width: 100, height: 100, crop: :limit }
  ] if ENV['CLOUDINARY_URL'].present?
end
