require 'nokogiri'
require 'open-uri'

class TalksController < ApplicationController
  before_filter :require_logged_user, :only => [:index, :new, :create]

  def index 
    @talks = current_user.talks.order_by(:created_at => "DESC").entries
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
    begin
      @talk = Talk.find(params[:id])

      unless @talk.to_public
        if logged_in?
          @talk = nil if @talk.user.id != current_user.id
        else
          @talk = nil
        end
      end
    rescue Mongoid::Errors::DocumentNotFound
      redirect_to root_path
    end
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