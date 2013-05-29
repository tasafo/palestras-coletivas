require 'nokogiri'
require 'open-uri'

class Oembed
  attr_accessor :title, :code, :thumbnail, :success

  def initialize(url)
    begin
      xml = Nokogiri::XML(open("http://www.slideshare.net/api/oembed/2?url=#{url}&format=xml"))

      unless xml.nil?
        @title = xml.xpath("//title").text
        @code = xml.xpath("//slideshow-id").text
        @thumbnail = xml.xpath("//thumbnail").text
        @success = true
      end
    rescue OpenURI::HTTPError
      @success = false
    end
  end
end
