require 'multi_json'
require 'open-uri'

#:nodoc:
class Speakerdeck
  def self.frame(code)
    "<iframe class=\"embed-responsive-item\"
    src=\"https://speakerdeck.com/player/#{code}\"
    allowfullscreen=\"true\"
    allowtransparency=\"true\" mozallowfullscreen=\"true\"
    style=\"border:0; padding:0; margin:0; background:transparent;\"
    webkitallowfullscreen=\"true\"></iframe>"
  end

  def self.extract(url)
    begin
      record = MultiJson.load(
        open("https://speakerdeck.com/oembed.json?url=#{url}")
      )
    rescue OpenURI::HTTPError
      record = nil
    end

    fields(record)
  end

  def self.fields(record)
    unless record.nil?
      html_field = record['html']
      title = record['title']
      code = html_field.match(%r{player\/(.*)\" style})[1]
      thumbnail = "https://speakerd.s3.amazonaws.com/presentations/#{code}/thumb_slide_0.jpg"

      { title: title, code: code, thumbnail: thumbnail, description: '' }
    end
  end
end
