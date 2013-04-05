require 'nokogiri'
require 'open-uri'

class TalksController < ApplicationController
  before_filter :require_logged_user, :only => [:new, :create, :edit, :update]

  def index
    @talk = Talk.new
    @search = ""

    if params[:my].nil?
      if params[:talk].nil?
        @talks = all_public_talks
      else
        @search = params[:talk][:search]

        if @search.empty?
          @talks = all_public_talks
        else
          @talks = Kaminari.paginate_array(Talk.fulltext_search(@search, :index => 'fulltext_index_talks', :published => [ true ])).page(params[:page]).per(5)
        end
      end
    else
      @talks = current_user.talks.page(params[:page]).per(5).order_by(:created_at => :desc) if logged_in?
    end
  end

  def new
    @talk = Talk.new
    
    list_authors
  end

  def create
    @talk = Talk.new(params[:talk])
    @talk.owner = current_user.id
    @talk.users << current_user

    list_authors

    if @talk.save
      if params[:users]
        params[:users].each do |a|
          user = User.find(a)
          @talk.users << [user] if user
        end
      end

      redirect_to talk_path(@talk), :notice => t("flash.talks.create.notice")
    else
      render :new
    end
  end

  def show
    begin
      @talk = Talk.find(params[:id])
      @authorized = authorized_access?(@talk)

      unless @talk.to_public
        @talk = nil unless @authorized
      end
    rescue Mongoid::Errors::DocumentNotFound
      redirect_to root_path
    end
  end

  def info_url
    url = params[:link]

    begin
      xml = Nokogiri::XML(open("http://www.slideshare.net/api/oembed/2?url=#{url}&format=xml"))

      unless xml.nil?
        title = xml.xpath("//title").text
        code = xml.xpath("//slideshow-id").text
        thumbnail = xml.xpath("//thumbnail").text

        respond_to do |format|
          format.json { render :json => {:error => false, :title => title, :code => code, :thumbnail => thumbnail} }
        end
      end
    rescue OpenURI::HTTPError
      respond_to do |format|
        format.json { render :json => {:error => true} }
      end
    end
  end

  def edit
    @talk = Talk.find(params[:id])

    list_authors

    unauthorized = @talk.owner == current_user.id.to_s ? false : true

    redirect_to talks_path, :notice => t("flash.unauthorized_access") if unauthorized
  end

  def update
    @talk = Talk.find(params[:id])

    list_authors

    if @talk.update_attributes(params[:talk])
      @talk.users = nil
      @talk.users << current_user
      if params[:users]
        params[:users].each do |a|
          user = User.find(a)
          @talk.users << [user] if user
        end
      end
      redirect_to talk_path(@talk), :notice => t("flash.talks.update.notice")
    else
      render :edit
    end
  end

private
  def all_public_talks
    Talk.where(:to_public => true).page(params[:page]).per(5).order_by(:created_at => :desc)
  end

  def list_authors
    @authors = User.not_in(:_id => current_user.id.to_s)
  end
end