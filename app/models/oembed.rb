require 'nokogiri'
require 'multi_json'
require 'open-uri'

class Oembed
  attr_accessor :url, :title, :code, :thumbnail

  def initialize(url, code = 0)
    @url = url
    @code = code
  end

  def open_presentation
    begin
      if @url.include? "slideshare.net"
        record = Nokogiri::XML(open("http://www.slideshare.net/api/oembed/2?url=#{@url}&format=xml"))

        unless record.nil?
          @title = record.xpath("//title").text
          @code = record.xpath("//slideshow-id").text
          @thumbnail = record.xpath("//thumbnail").text
          true
        end

      elsif @url.include? "speakerdeck.com"
        record = MultiJson.load(open("https://speakerdeck.com/oembed.json?url=#{@url}"))

        unless record.nil?
          html_field = record['html']
          @title = record["title"]
          @code = html_field.match(/player\/(.*)\" style/)[1]
          @thumbnail = "https://speakerd.s3.amazonaws.com/presentations/#{code}/thumb_slide_0.jpg"
          true
        end

      end

    rescue OpenURI::HTTPError
      false

    end
  end

  def show_presentation
    dimension = "width=\"427\" height=\"356\""

    if @url.include? "slideshare.net"
      "<iframe src=\"http://www.slideshare.net/slideshow/embed_code/#{@code}\" #{dimension} frameborder=\"0\" marginwidth=\"0\" marginheight=\"0\" scrolling=\"no\" style=\"border:1px solid #CCC;border-width:1px 1px 0;margin-bottom:5px\" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe>"
    elsif @url.include? "speakerdeck.com"
      "<iframe src=\"//speakerdeck.com/player/#{@code}\" #{dimension} allowfullscreen=\"true\" allowtransparency=\"true\" frameborder=\"0\" id=\"talk_frame_8863\" mozallowfullscreen=\"true\" style=\"border:0; padding:0; margin:0; background:transparent;\" webkitallowfullscreen=\"true\"></iframe>"
    else
      "<img src=\"/assets/without_presentation.jpg\" #{dimension} />"
    end
  end
end
