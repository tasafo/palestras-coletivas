#:nodoc:
class Fonts
  attr_reader :file_name

  def initialize
    @file_name = "#{Rails.public_path}/fonts.txt"
  end

  def list
    list = []

    if File.exist?(@file_name)
      File.open(@file_name).each do |line|
        list << line
      end
    end

    list
  end
end
