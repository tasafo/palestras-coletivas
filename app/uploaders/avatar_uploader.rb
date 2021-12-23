class AvatarUploader < Uploader
  if CloudinaryReady.up?
    cloudinary_transformation transformation: [
      { width: 100, height: 100, crop: :limit }
    ]
  end
end
