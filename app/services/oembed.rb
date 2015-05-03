require 'nokogiri'
require 'multi_json'
require 'open-uri'

class Oembed
  attr_reader :url, :title, :code, :thumbnail, :frame, :description

  def initialize(url, code = 0)
    @url = url
    @code = code
  end

  def open_presentation
    if @url.include? "slideshare.net"
      open_slideshare
    elsif @url.include? "speakerdeck.com"
      open_speakerdeck
    elsif @url.include? "prezi.com"
      open_prezi
    end
  end

  def show_presentation
    dimension = "width=\"80%\" height=\"500\""

    if @url.include? "slideshare.net"
      @frame = "<iframe class=\"embed-responsive-item\" src=\"http://www.slideshare.net/slideshow/embed_code/#{@code}\" marginwidth=\"0\" marginheight=\"0\" scrolling=\"no\" style=\"border:1px solid #CCC;border-width:1px 1px 0;margin-bottom:5px\" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe>"
    elsif @url.include? "speakerdeck.com"
      @frame = "<iframe class=\"embed-responsive-item\" src=\"//speakerdeck.com/player/#{@code}\" allowfullscreen=\"true\" allowtransparency=\"true\" mozallowfullscreen=\"true\" style=\"border:0; padding:0; margin:0; background:transparent;\" webkitallowfullscreen=\"true\"></iframe>"
    elsif @url.include? "prezi.com"
      @frame = "<iframe class=\"embed-responsive-item\" src=\"https://prezi.com/embed/#{@code}/?bgcolor=ffffff&amp;lock_to_path=0&amp;autoplay=0&amp;autohide_ctrls=0#\" allowfullscreen=\"\" mozallowfullscreen=\"\" webkitallowfullscreen=\"\"></iframe>"
    else
      @frame = "<img src=\"/assets/without_presentation.jpg\" #{dimension} />"
    end
    self
  end

  def show_video
    video_url = nil

    unless @url.nil?
      if @url.include? "youtube.com"
        video_url = "http://www.youtube.com/oembed?url=#{@url}&format=json"
      elsif @url.include? "vimeo.com"
        video_url = "http://vimeo.com/api/oembed.json?url=#{@url}"
      end
    end

    begin
      if video_url.nil?
        nil
      else
        record = MultiJson.load(open(video_url))

        unless record.nil?
          @title = record["title"]
          @frame = record['html']
          self
        end
      end
    rescue OpenURI::HTTPError
      nil
    end
  end

private

  def open_slideshare
    begin
      record = Nokogiri::XML(open("http://www.slideshare.net/api/oembed/2?url=#{@url}&format=xml"))

      unless record.nil?
        @title = record.xpath("//title").text
        @code = record.xpath("//slideshow-id").text
        @thumbnail = record.xpath("//thumbnail").text
        @description = ""
        self
      end
    rescue OpenURI::HTTPError
      nil
    end
  end

  def open_speakerdeck
    begin
      record = MultiJson.load(open("https://speakerdeck.com/oembed.json?url=#{@url}"))

      unless record.nil?
        html_field = record['html']
        @title = record["title"]
        @code = html_field.match(/player\/(.*)\" style/)[1]
        @thumbnail = "https://speakerd.s3.amazonaws.com/presentations/#{code}/thumb_slide_0.jpg"
        @description = ""
        self
      end
    rescue OpenURI::HTTPError
      nil
    end
  end

  def open_prezi
    begin
      code = @url.split("/")[3]
      record = MultiJson.load(open("https://prezi.com/api/embed/?id=#{code}"))

      if !record.nil? && record["error_code"].nil?
        @title = record["presentation"]["title"]
        @code = record["presentation"]["oid"]
        @thumbnail = record["presentation"]["thumb_url"]
        @description = record["presentation"]["description"]
        self
      end
    rescue OpenURI::HTTPError
      nil
    end
  end
end
