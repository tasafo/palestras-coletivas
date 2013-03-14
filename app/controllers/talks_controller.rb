require 'nokogiri'
require 'open-uri'

class TalksController < ApplicationController
  before_filter :require_logged_user, :only => [:new, :create]

  def index 
    @talks = Talk.all.entries
  end

  def new
    @talk = Talk.new
  end

  def create
    @talk = current_user.talks.new(params[:talk])

    if @talk.save
      redirect_to talk_path(@talk), :notice => t("flash.talks.create.notice")
    else
      render :new
    end
  end

  def show
    @talk = Talk.find(params[:id])
  end

  def get_info_url
    url = params[:link]

    xml = Nokogiri::XML(open("http://www.slideshare.net/api/oembed/2?url=#{url}&format=xml"))

    unless xml.nil?
      title = xml.xpath("//title").text
      code = xml.xpath("//slideshow-id").text
      thumbnail = xml.xpath("//thumbnail").text

      respond_to do |format|
        format.json { render :json => {:title => title, :code => code, :thumbnail => thumbnail} }
      end
    end
  end
end