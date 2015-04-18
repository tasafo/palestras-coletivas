require 'nokogiri'
require 'open-uri'

class Gravatar
  DOMAIN = "http://gravatar.com"

  attr_reader :url, :profile, :profile_url, :about_me, :current_location, :has_profile, :email

  def initialize(email)
    hash = Digest::MD5.hexdigest(email)

    @email = email
    @url = "#{DOMAIN}/avatar/#{hash}?d=mm"
    @profile = "#{DOMAIN}/#{hash}"
  end

  def get_fields
    begin
      if @profile
        record = Nokogiri::XML(open("#{@profile}.xml"))

        @profile_url = record.xpath("//profileUrl").text
        @about_me = record.xpath("//aboutMe").text
        @current_location = record.xpath("//currentLocation").text
        @has_profile = true
        self
      end
    rescue OpenURI::HTTPError
      @has_profile = false
      self
    end
  end

  def self.get_facebook_photo(url)
    begin
      unless url.blank?
        id = url.split("/").last
        id = id.split("?").first if id.include?("?")

        object = open("https://graph.facebook.com/#{id}/picture?type=large")

        image_url = object.base_uri.to_s

        image_url.include?("gPCjrIGykBe.gif") ? nil : image_url
      end
    rescue
      nil
    end
  end

  def get_image
    user = User.find_by(email: @email)

    if user
      user.facebook_photo.nil? ? @url : user.facebook_photo
    else
      @url
    end
  end
end
