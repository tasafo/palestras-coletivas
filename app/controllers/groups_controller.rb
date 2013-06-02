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
      @group = Group.find params[:id]
      @owns = owner? @group
      @gravatar = Gravatar.new @group.gravatar_url
      @gravatar.show_profile
    rescue Mongoid::Errors::DocumentNotFound
      redirect_to root_path
    end
  end

  def info_url
    gravatar = Gravatar.new params[:link]

    respond_to do |format|
      if gravatar.open_profile
        format.json { render :json => {:error => false, :name => gravatar.name, :thumbnail_url => gravatar.thumbnail_url} }
      else
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