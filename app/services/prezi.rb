require 'multi_json'
require 'open-uri'

#:nodoc:
class Prezi
  def self.frame(code)
    "<iframe class=\"embed-responsive-item\"
    src=\"https://prezi.com/embed/#{code}/?bgcolor=ffffff&amp;
    lock_to_path=0&amp;autoplay=0&amp;autohide_ctrls=0#\"
    allowfullscreen=\"\" mozallowfullscreen=\"\"
    webkitallowfullscreen=\"\"></iframe>"
  end

  def self.extract(url)
    begin
      code = url.split('/')[3]
      record = MultiJson.load(
        open("https://prezi.com/api/embed/?id=#{code}")
      )
    rescue OpenURI::HTTPError
      record = nil
    end

    fields(record)
  end

  def self.fields(record)
    if !record.nil? && record['error_code'].nil?
      title = record['presentation']['title']
      code = record['presentation']['oid']
      thumbnail = record['presentation']['thumb_url']
      description = record['presentation']['description']

      { title: title, code: code, thumbnail: thumbnail,
        description: description }
    end
  end
end
