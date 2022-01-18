require 'nokogiri'

class Slideshare
  DOMAIN = 'slideshare.net'.freeze
  URL = "https://www.#{DOMAIN}".freeze

  def self.frame(code)
    "<iframe src=\"#{URL}/slideshow/embed_code/#{code}\"
    marginwidth=\"0\" marginheight=\"0\" scrolling=\"no\"
    style=\"border:1px solid #CCC;border-width:1px 1px 0;
    margin-bottom:5px\"
    allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe>"
  end

  def self.extract(url)
    begin
      record = Nokogiri::XML(
        URI.parse("#{URL}/api/oembed/2?url=#{url}&format=xml").open
      )
    rescue OpenURI::HTTPError
      record = nil
    end

    fields(record)
  end

  def self.fields(record)
    return unless record

    title = record.xpath('//title').text
    code = record.xpath('//slideshow-id').text
    thumbnail = record.xpath('//thumbnail').text

    { title: title, code: code, thumbnail: thumbnail, description: '' }
  end
end
