require 'nokogiri'

class Gravatar
  DOMAIN = 'gravatar.com'.freeze
  URL = "https://#{DOMAIN}".freeze

  attr_reader :url, :profile, :profile_url, :about_me, :current_location,
              :has_profile, :email, :thumbnail_url

  def initialize(email)
    hash = Digest::MD5.hexdigest(email)
    @email = email
    @url = "#{URL}/avatar/#{hash}?d=mm"
    @profile = "#{URL}/#{hash}"
    @has_profile = false
    fields
  end

  private

  def fields
    record = extract(@profile) if @profile

    return unless record

    @profile_url = Utility.https(record.xpath('//profileUrl').text)
    @about_me = record.xpath('//aboutMe').text
    @current_location = record.xpath('//currentLocation').text
    @thumbnail_url = record.xpath('//thumbnailUrl').text
    @has_profile = true
  end

  def extract(profile)
    url = "#{profile}.xml"

    begin
      Nokogiri::XML(URI.parse(url).open)
    rescue OpenURI::HTTPError
      nil
    end
  end
end
