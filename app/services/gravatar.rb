require 'nokogiri'

class Gravatar
  attr_reader :url, :profile, :profile_url, :about_me, :current_location,
              :has_profile, :email, :thumbnail_url

  def initialize(email)
    hash = Digest::MD5.hexdigest(email)
    domain = 'https://pt.gravatar.com'

    @email = email
    @url = "#{domain}/avatar/#{hash}?d=mm"
    @profile = "#{domain}/#{hash}"
  end

  def fields
    record = extract(@profile) if @profile

    @has_profile = false

    unless record.nil?
      @profile_url = record.xpath('//profileUrl').text
      @about_me = record.xpath('//aboutMe').text
      @current_location = record.xpath('//currentLocation').text
      @thumbnail_url = record.xpath('//thumbnailUrl').text
      @has_profile = true
    end

    self
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
