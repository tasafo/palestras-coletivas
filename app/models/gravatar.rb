require 'nokogiri'
require 'open-uri'

class Gravatar
  attr_accessor :url, :name, :thumbnail_url, :profile_url, :about_me, :current_location, :has_profile

  def initialize(url)
    @url = url
  end

  def self.url(email)
    hash = Digest::MD5.hexdigest(email)

    "http://gravatar.com/avatar/#{hash}?d=mm"
  end

  def self.profile(email)
    hash = Digest::MD5.hexdigest(email)

    "http://gravatar.com/#{hash}"
  end

  def show_profile
    begin
      unless @url.blank?
        record = Nokogiri::XML(open("#{@url}.xml"))

        @profile_url = record.xpath("//profileUrl").text
        @about_me = record.xpath("//aboutMe").text
        @current_location = record.xpath("//currentLocation").text
        @has_profile = true
      end
    rescue OpenURI::HTTPError, SocketError
      @has_profile = false
    end
  end

  def open_profile
    begin
      record = Nokogiri::XML(open("#{@url}.xml"))

      unless record.nil?
        @name = record.xpath("//displayName").text
        @thumbnail_url = record.xpath("//thumbnailUrl").text
        true
      end
    rescue OpenURI::HTTPError
      false
    end
  end
end