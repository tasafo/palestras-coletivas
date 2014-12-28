class TalksController < ApplicationController
  before_action :require_logged_user, only: [:new, :create, :edit, :update]
  before_action :set_talk, only: [:show, :edit, :update]
  before_action :set_authors, only: [:new, :create, :edit, :update]

  def index
    @search = params[:search]
    @my = !params[:my].nil?

    @talks = search_talks @search, @my, params[:page]

    respond_to do |format|
      format.html
      format.json { render json: @talks.only('id', 'name', 'description', 'tags', 'presentation_url', 'thumbnail') }
    end
  end

  def new
    @talk = Talk.new
  end

  def create
    @talk = Talk.new(talk_params)

    if TalkDecorator.new(@talk).create(params[:users], current_user)
      redirect_to talk_path(@talk), notice: t("flash.talks.create.notice")
    else
      render :new
    end
  end

  def show
    unless @talk.nil?
      @authorized = authorized_access? @talk
      @owns = owner? @talk

      @presentation = Oembed.new(@talk.presentation_url, @talk.code).show_presentation

      @video = Oembed.new(@talk.video_link).show_video

      unless @talk.to_public
        @talk = nil unless @authorized
      end
    else
      redirect_to root_path
    end
  end

  def info_url
    oembed = Oembed.new(params[:link]).open_presentation

    respond_to do |format|
      if oembed
        format.json { render :json => {:error => false, :title => oembed.title, :code => oembed.code, :thumbnail => oembed.thumbnail} }
      else
        format.json { render :json => {:error => true} }
      end
    end
  end

  def edit
    redirect_to talks_path, :notice => t("flash.unauthorized_access") unless (@talk.owner.to_s == current_user.id.to_s)
  end

  def update
    if TalkDecorator.new(@talk).update(params[:users], talk_params)
      redirect_to talk_path(@talk), notice: t("flash.talks.update.notice")
    else
      render :edit
    end
  end

  def watch
    @talk = Talk.find(params[:talk_id])

    current_user.watch_talk! @talk
    redirect_to talk_path(@talk)
  end

  def unwatch
    @talk = Talk.find(params[:talk_id])

    current_user.unwatch_talk! @talk
    redirect_to talk_path(@talk)
  end

private

  def search_talks(search, my, page)
    talks = TalkQuery.new.publics if search.blank?

    talks = Kaminari.paginate_array(TalkQuery.new.search(search)) unless search.blank?

    talks = current_user.talks.desc(:created_at) if logged_in? && my

    talks.page(page).per(5)
  end

  def set_talk
    @talk = Talk.find(params[:id])
  end

  def set_authors
    @authors = UserQuery.new.without_the_owner current_user
  end

  def talk_params
    params.require(:talk).permit(:presentation_url, :title, :description, :tags, :video_link, :to_public, :thumbnail, :code)
  end
end
