require 'nokogiri'
require 'open-uri'

class Gravatar
  DOMAIN = "http://gravatar.com"

  attr_reader :url, :profile, :profile_url, :about_me, :current_location, :has_profile

  def initialize(email)
    hash = Digest::MD5.hexdigest(email)

    @url = "#{DOMAIN}/avatar/#{hash}?d=mm"
    @profile = "#{DOMAIN}/#{hash}"

    get_profile
  end

private

  def get_profile
    begin
      if @profile
        record = Nokogiri::XML(open("#{@profile}.xml"))

        @profile_url = record.xpath("//profileUrl").text
        @about_me = record.xpath("//aboutMe").text
        @current_location = record.xpath("//currentLocation").text
        @has_profile = true
      end
    rescue OpenURI::HTTPError
      @has_profile = false
    end
  end
end
