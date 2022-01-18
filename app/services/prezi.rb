class Prezi
  DOMAIN = 'prezi.com'.freeze
  URL = "https://#{DOMAIN}".freeze

  def self.frame(code)
    "<iframe src=\"#{URL}/embed/#{code}/?bgcolor=ffffff&amp;
    lock_to_path=0&amp;autoplay=0&amp;autohide_ctrls=0#\"
    allowfullscreen=\"\" mozallowfullscreen=\"\"
    webkitallowfullscreen=\"\"></iframe>"
  end

  def self.extract(url)
    begin
      code = url.split('/')[3]
      record = MultiJson.load(
        URI.parse("#{URL}/api/embed/?id=#{code}").open
      )
    rescue OpenURI::HTTPError
      record = nil
    end

    fields(record)
  end

  def self.fields(record)
    return unless record
    return if record['error_code']

    presentation = record['presentation']

    { title: presentation['title'], code: presentation['oid'],
      thumbnail: presentation['thumb_url'],
      description: presentation['description'] }
  end
end
