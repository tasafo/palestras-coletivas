class TalksController < ApplicationController
  before_filter :require_logged_user, :only => [:new, :create, :edit, :update]

  def index
    @talk = Talk.new
    @search = ""

    if params[:my].nil?
      @my = false
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
      @my = true
      @talks = current_user.talks.page(params[:page]).per(5).order_by(:created_at => :desc) if logged_in?
    end
  end

  def new
    @talk = Talk.new

    @authors = User.without_the_owner current_user
  end

  def create
    @talk = Talk.new(params[:talk])

    @talk.add_authors current_user, params[:users]

    @authors = User.without_the_owner current_user

    if @talk.save
      @talk.update_user_counters

      redirect_to talk_path(@talk), :notice => t("flash.talks.create.notice")
    else
      render :new
    end
  end

  def show
    begin
      @talk = Talk.find(params[:id])
      @authorized = authorized_access? @talk
      @owns = owner? @talk

      oembed = Oembed.new @talk.presentation_url, @talk.code
      @frame = oembed.frame

      unless @talk.to_public
        @talk = nil unless @authorized
      end
    rescue Mongoid::Errors::DocumentNotFound
      redirect_to root_path
    end
  end

  def info_url
    oembed = Oembed.new params[:link]

    respond_to do |format|
      if oembed.open_url
        format.json { render :json => {:error => false, :title => oembed.title, :code => oembed.code, :thumbnail => oembed.thumbnail} }
      else
        format.json { render :json => {:error => true} }
      end
    end
  end

  def edit
    @talk = Talk.find(params[:id])

    @authors = User.without_the_owner current_user

    unauthorized = @talk.owner == current_user.id.to_s ? false : true

    redirect_to talks_path, :notice => t("flash.unauthorized_access") if unauthorized
  end

  def update
    @talk = Talk.find(params[:id])

    @talk.add_authors current_user, params[:users]

    @authors = User.without_the_owner current_user

    if @talk.update_attributes(params[:talk])
      @talk.update_user_counters

      redirect_to talk_path(@talk), :notice => t("flash.talks.update.notice")
    else
      render :edit
    end
  end

  def watch
    @talk = Talk.find(params[:id])

    current_user.watch_talk! @talk
    redirect_to talk_path(@talk)
  end

  def unwatch
    @talk = Talk.find(params[:id])

    current_user.unwatch_talk! @talk
    redirect_to talk_path(@talk)
  end

private
  def all_public_talks
    Talk.where(:to_public => true).page(params[:page]).per(5).order_by(:created_at => :desc)
  end
end
