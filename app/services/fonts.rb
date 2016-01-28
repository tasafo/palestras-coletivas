class Fonts
  FILE_NAME = "#{Rails.public_path}/fonts.txt"

  def self.list
    list = []

    if File.exists?(FILE_NAME)
      File.open(FILE_NAME).each do |line|
        list << line
      end
    end

    list
  end
end
