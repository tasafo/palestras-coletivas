require 'multi_json'

class Oembed
  YOUTUBE_DOMAIN = 'youtube.com'.freeze
  VIMEO_DOMAIN = 'vimeo.com'.freeze

  attr_reader :url, :title, :code, :thumbnail, :frame, :description

  def initialize(url, code = 0)
    @url = url
    @code = code
    @without_presentation = '<img src="/without_presentation.jpg"
      width="80%" height="500" />'
  end

  def open_presentation
    fields = case @url
             when /#{Slideshare::DOMAIN}/
               Slideshare.extract(@url)
             when /#{Speakerdeck::DOMAIN}/
               Speakerdeck.extract(@url)
             when /#{Prezi::DOMAIN}/
               Prezi.extract(@url)
             end

    fill(fields)
  end

  def fill(fields)
    return if fields.blank?

    @title = fields[:title]
    @code = fields[:code]
    @thumbnail = fields[:thumbnail]
    @description = fields[:description]

    self
  end

  def show_presentation
    @frame = case @url
             when /#{Slideshare::DOMAIN}/
               Slideshare.frame(@code)
             when /#{Speakerdeck::DOMAIN}/
               Speakerdeck.frame(@code)
             when /#{Prezi::DOMAIN}/
               Prezi.frame(@code)
             else
               @without_presentation
             end
    self
  end

  def show_video
    record = open_url

    return unless record

    @title = record['title']
    @frame = record['html']

    self
  end

  def open_url
    url = video_url
    begin
      MultiJson.load(URI.parse(url).open) if url
    rescue OpenURI::HTTPError
      nil
    end
  end

  def video_url
    case @url
    when /#{YOUTUBE_DOMAIN}/
      "https://#{YOUTUBE_DOMAIN}/oembed?url=#{@url}&format=json"
    when /#{VIMEO_DOMAIN}/
      "https://#{VIMEO_DOMAIN}/api/oembed.json?url=#{@url}"
    end
  end
end
