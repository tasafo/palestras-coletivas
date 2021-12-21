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
        URI.parse("https://speakerdeck.com/oembed.json?url=#{url}").open
      )
    rescue OpenURI::HTTPError
      record = nil
    end

    fields(record)
  end

  def self.fields(record)
    return unless record

    html_field = record['html']
    title = record['title']
    code = html_field.match(%r{player/(.*)"})[1].split('"')[0]
    url = 'https://files.speakerdeck.com'
    thumbnail = "#{url}/presentations/#{code}/preview_slide_0.jpg"

    { title: title, code: code, thumbnail: thumbnail, description: '' }
  end
end
