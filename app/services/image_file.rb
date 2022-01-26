class ImageFile
  def self.remove(file)
    if CloudinaryReady.up?
      Cloudinary::Uploader.destroy(file.public_id) if file&.public_id
    else
      file_path = file.path
      File.delete(file_path) if File.exist?(file_path)
    end
  end

  def self.asset(file)
    Rails.root.join('spec', 'support', 'assets', 'images', file)
  end
end
