require 'multi_json'

#:nodoc:
class Oembed
  attr_reader :url, :title, :code, :thumbnail, :frame, :description

  def initialize(url, code = 0)
    @url = url
    @code = code
    @without_presentation = '<img src="/without_presentation.jpg"
      width="80%" height="500" />'
  end

  def open_presentation
    fields = if @url.include? 'slideshare.net'
               Slideshare.extract(@url)
             elsif @url.include? 'speakerdeck.com'
               Speakerdeck.extract(@url)
             elsif @url.include? 'prezi.com'
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
    @frame = if @url.include? 'slideshare.net'
               Slideshare.frame(@code)
             elsif @url.include? 'speakerdeck.com'
               Speakerdeck.frame(@code)
             elsif @url.include? 'prezi.com'
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
    return if @url.nil?

    if @url.include? 'youtube.com'
      "https://www.youtube.com/oembed?url=#{@url}&format=json"
    elsif @url.include? 'vimeo.com'
      "https://vimeo.com/api/oembed.json?url=#{@url}"
    end
  end
end
