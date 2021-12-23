class ImageUploader < Uploader
  if CloudinaryReady.up?
    cloudinary_transformation transformation: [
      { width: 1920, height: 1080, crop: :limit }
    ]
  end
end
