require 'nokogiri'
require 'open-uri'

class GroupsController < ApplicationController
  before_filter :require_logged_user, :only => [:new, :create, :edit, :update]

  def index
    if logged_in?
      @groups = current_user.groups.order_by(:name => :asc)
    else
      @groups = Group.all.order_by(:name => :asc)
    end
  end

  def new
    @group = Group.new
    @members = User.not_in(:_id => current_user.id.to_s).order_by(:name => :asc)
  end

  def create
    @group = Group.new(params[:group])
    @group.owner = current_user.id
    @group.users << current_user

    if @group.save
      if params[:members]
        params[:members].each do |m|
          user = User.find(m)
          @group.users << [user] if user
        end
      end

      redirect_to group_path(@group), :notice => t("flash.groups.create.notice")
    else
      render :new
    end
  end

  def show
    begin
      @group = Group.find(params[:id])
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
    @members = User.not_in(:_id => current_user.id.to_s).order_by(:name => :asc)

    unauthorized = @group.owner == current_user.id.to_s ? false : true

    redirect_to groups_path, :notice => t("flash.unauthorized_access") if unauthorized
  end

  def update
    @group = Group.find(params[:id])

    if @group.update_attributes(params[:group])
      @group.users = nil
      @group.users << current_user
      if params[:members]
        params[:members].each do |m|
          user = User.find(m)
          @group.users << [user] if user
        end
      end
      redirect_to group_path(@group), :notice => t("flash.groups.update.notice")
    else
      render :edit
    end 
  end
end