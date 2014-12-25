class TalksController < ApplicationController
  before_filter :require_logged_user, :only => [:new, :create, :edit, :update]
  before_action :set_talk, only: [:show, :edit, :update]

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

    @authors = User.without_the_owner current_user
  end

  def create
    @talk = Talk.new(talk_params)

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
    unless @talk.nil?
      @authorized = authorized_access? @talk
      @owns = owner? @talk

      @presentation = Oembed.new @talk.presentation_url, @talk.code
      @presentation.show_presentation

      @video = Oembed.new @talk.video_link
      @video.show_video

      unless @talk.to_public
        @talk = nil unless @authorized
      end
    else
      redirect_to root_path
    end
  end

  def info_url
    oembed = Oembed.new params[:link]

    respond_to do |format|
      if oembed.open_presentation
        format.json { render :json => {:error => false, :title => oembed.title, :code => oembed.code, :thumbnail => oembed.thumbnail} }
      else
        format.json { render :json => {:error => true} }
      end
    end
  end

  def edit
    @authors = User.without_the_owner current_user

    unauthorized = @talk.owner == current_user.id.to_s ? false : true

    redirect_to talks_path, :notice => t("flash.unauthorized_access") if unauthorized
  end

  def update
    @talk.add_authors current_user, params[:users]

    @authors = User.without_the_owner current_user

    if @talk.update_attributes(talk_params)
      @talk.update_user_counters

      redirect_to talk_path(@talk), :notice => t("flash.talks.update.notice")
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
      if my
        current_user.talks.page(page).per(5).desc(:created_at) if logged_in?
      else
        if search.blank?
          Talk.where(to_public: true).page(page).per(5).desc(:created_at)
        else
          Kaminari.paginate_array(Talk.search(search)).page(page).per(5)
        end
      end
    end

    def set_talk
      @talk = Talk.find(params[:id])
    end

    def talk_params
      params.require(:talk).permit(:presentation_url, :title, :description, :tags, :video_link, :to_public, :thumbnail, :code)
    end
end
