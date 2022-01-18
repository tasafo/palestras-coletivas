class Speakerdeck
  DOMAIN = 'speakerdeck.com'.freeze
  URL = "https://#{DOMAIN}".freeze
  FILES_URL = "https://files.#{DOMAIN}".freeze

  def self.frame(code)
    "<iframe src=\"#{URL}/player/#{code}\"
    allowfullscreen=\"true\"
    allowtransparency=\"true\" mozallowfullscreen=\"true\"
    style=\"border:0; padding:0; margin:0; background:transparent;\"
    webkitallowfullscreen=\"true\"></iframe>"
  end

  def self.extract(url)
    begin
      record = MultiJson.load(
        URI.parse("#{URL}/oembed.json?url=#{url}").open
      )
    rescue OpenURI::HTTPError
      record = nil
    end

    fields(record)
  end

  def self.fields(record)
    return unless record

    code = record['html'].match(%r{player/(.*)"})[1].split('"')[0]
    thumbnail = "#{FILES_URL}/presentations/#{code}/preview_slide_0.jpg"

    { title: record['title'], code: code, thumbnail: thumbnail, description: '' }
  end
end
