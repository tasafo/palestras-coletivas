class AvatarUploader < Uploader
  if ENV['CLOUDINARY_URL'].present?
    cloudinary_transformation transformation: [
      { width: 100, height: 100, crop: :limit }
    ]
  end
end
