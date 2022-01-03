class TalksController < ApplicationController
  before_action :require_logged_user, only: %i[new create edit update]
  before_action :set_talk, only: %i[show edit update destroy]
  before_action :set_authors, only: %i[new create edit update]
  before_action :check_authorization, only: %i[edit destroy]

  def index
    query = TalkQuery.new.select(current_user, params[:search], params[:my]).to_a
    @pagy, @records = pagy(query, count: query.count)

    respond_to do |format|
      format.html
      format.json { render jsonapi: @records, meta: { total: @records.size } }
    end
  end

  def new
    @talk = Talk.new
  end

  def create
    @talk = Talk.new(talk_params.to_h.merge({ owner: current_user }))

    render :new and return if @talk.invalid?

    attributes = prepare_attributes(current_user, :create, talk_params)

    @talk = Talk.create(attributes)

    redirect_to talk_path(@talk), notice: t('flash.talks.create.notice') if @talk
  end

  def show
    @authorized = authorized_access? @talk
    @user_owns = user_owner? @talk

    @presentation = Oembed.new(@talk.presentation_url, @talk.code).show_presentation
    @presenteds = @talk.schedules.presenteds.to_a

    @video = Oembed.new(@talk.video_link).show_video

    return if @talk.to_public

    @talk = nil unless @authorized
  end

  def edit; end

  def update
    @talk.refresh(talk_params)

    render :edit and return if @talk.invalid?

    attributes = prepare_attributes(@talk.owner, :update, talk_params)

    saved = @talk.update(attributes)

    redirect_to talk_path(@talk), notice: t('flash.talks.update.notice') if saved
  end

  def destroy
    if @talk.destroy
      redirect_to talks_path, notice: t('notice.destroyed', model: t('mongoid.models.talk'))
    else
      redirect_to talk_path(@talk), notice: t('notice.delete.restriction.talks')
    end
  end

  private

  def set_talk
    @talk = Talk.with_users.with_watched_users.find(params[:id])

    found = @talk && (@talk.owner == current_user || @talk.to_public)

    return if found

    redirect_to talks_path, notice: t('notice.not_found', model: t('mongoid.models.talk'))
  end

  def set_authors
    @authors = UserQuery.new.without_the_owner current_user
  end

  def check_authorization
    return if authorized_access?(@talk)

    redirect_to talks_path, notice: t('flash.unauthorized_access')
  end

  def talk_params
    params.require(:talk).permit(:presentation_url, :title, :description,
                                 :tags, :video_link, :to_public, :thumbnail, :code)
  end
end
