require 'nokogiri'
require 'open-uri'

class Gravatar
  DOMAIN = "https://pt.gravatar.com"

  attr_reader :url, :profile, :profile_url, :about_me, :current_location, :has_profile, :email, :thumbnail_url

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
        @thumbnail_url = record.xpath("//thumbnailUrl").text
        @has_profile = true
        self
      end
    rescue OpenURI::HTTPError
      @has_profile = false
      self
    end
  end
end
