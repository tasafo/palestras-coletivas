require 'nokogiri'
require 'open-uri'

class GroupsController < ApplicationController
  before_filter :require_logged_user, :only => [:new, :create, :edit, :update]

  def index
    if params[:my].nil?
      @groups = Group.all.by_name
      @my = false
    else
      @groups = current_user.groups.by_name if logged_in?
      @my = true
    end
  end

  def new
    @group = Group.new

    @members = User.without_the_owner current_user
  end

  def create
    @group = Group.new(params[:group])

    @group.add_members current_user, params[:users]

    @members = User.without_the_owner current_user

    if @group.save
      redirect_to group_path(@group), :notice => t("flash.groups.create.notice")
    else
      render :new
    end
  end

  def show
    begin
      @group = Group.find(params[:id])

      profile = @group.gravatar_url

      begin
        unless profile.blank?
          xml = Nokogiri::XML(open("#{profile}.xml"))

          @profile_url = xml.xpath("//profileUrl").text
          @about_me = xml.xpath("//aboutMe").text
          @current_location = xml.xpath("//currentLocation").text
          @has_gravatar_profile = true
        end
      rescue OpenURI::HTTPError, SocketError
        @has_gravatar_profile = false
      end
    rescue Mongoid::Errors::DocumentNotFound
      redirect_to root_path
    end
  end

  def info_url
    url = params[:link]

    begin
      xml = Nokogiri::XML(open("#{url}.xml"))

      unless xml.nil?
        name = xml.xpath("//displayName").text
        thumbnail_url = xml.xpath("//thumbnailUrl").text

        respond_to do |format|
          format.json { render :json => {:error => false, :name => name, :thumbnail_url => thumbnail_url} }
        end
      end
    rescue OpenURI::HTTPError
      respond_to do |format|
        format.json { render :json => {:error => true} }
      end
    end
  end

  def edit
    @group = Group.find(params[:id])

    @members = User.without_the_owner current_user

    unauthorized = @group.owner == current_user.id.to_s ? false : true

    redirect_to groups_path, :notice => t("flash.unauthorized_access") if unauthorized
  end

  def update
    @group = Group.find(params[:id])

    @group.add_members current_user, params[:users]

    @members = User.without_the_owner current_user

    if @group.update_attributes(params[:group])
      redirect_to group_path(@group), :notice => t("flash.groups.update.notice")
    else
      render :edit
    end
  end
end