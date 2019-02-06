#:nodoc:
class TalksController < PersistenceController
  before_action :require_logged_user, only: [:new, :create, :edit, :update]
  before_action :set_talk, only: [:show, :edit, :update, :destroy]
  before_action :set_authors, only: [:new, :create, :edit, :update]
  before_action :check_authorization, only: [:edit, :destroy]

  def index
    @search = params[:search]
    @my = !params[:my].nil?
    @talk = Talk.new
    @talks = search_talks @search, @my, params[:page]

    render nothing: true, status: 404 if params[:page] && @talks.blank?
  end

  def new
    @talk = Talk.new
  end

  def create
    @talk = Talk.new(talk_params)

    save_object(@talk, params[:users], owner: current_user)
  end

  def show
    @authorized = authorized_access? @talk
    @owns = owner? @talk

    @presentation = Oembed.new(@talk.presentation_url, @talk.code)
                          .show_presentation

    @video = Oembed.new(@talk.video_link).show_video

    @talks = Talk.all.limit(8)

    return if @talk.to_public

    @talk = nil unless @authorized
  end

  def edit
  end

  def update
    save_object(@talk, params[:users], params: talk_params)
  end

  def destroy
    @talk.destroy

    if @talk.errors.blank?
      redirect_to talks_path,
        notice: t('notice.destroyed', model: t('mongoid.models.talk'))
    else
      redirect_to talk_path(@talk),
        notice: t('notice.delete.restriction.talks')
    end
  end

  private

  def search_talks(search, my, page)
    talks = if logged_in? && my
              TalkQuery.new.owner(current_user)
            else
              if search.blank?
                TalkQuery.new.publics
              else
                Kaminari.paginate_array(TalkQuery.new.search(search))
              end
            end

    talks.page(page).per(16)
  end

  def set_talk
    @talk = Talk.find(params[:id])

    found = !@talk.nil? && (@talk.owner == current_user || @talk.to_public)

    redirect_to talks_path, notice: t("notice.not_found",
              model: t("mongoid.models.talk")) if !found
  end

  def set_authors
    @authors = UserQuery.new.without_the_owner current_user
  end

  def check_authorization
    redirect_to talks_path,
      notice: t('flash.unauthorized_access') unless authorized_access?(@talk)
  end

  def talk_params
    params.require(:talk).permit(:presentation_url, :title, :description,
                                 :tags, :video_link, :to_public, :thumbnail,
                                 :code)
  end
end
