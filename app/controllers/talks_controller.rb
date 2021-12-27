class TalksController < PersistenceController
  before_action :require_logged_user, only: %i[new create edit update]
  before_action :set_talk, only: %i[show edit update destroy]
  before_action :set_authors, only: %i[new create edit update]
  before_action :check_authorization, only: %i[edit destroy]

  def index
    @search = params[:search]
    @my_talks = params[:my]
    query = search_talks(@search, @my_talks)
    @pagy, @records = pagy(query, count: query.count)

    respond_to do |format|
      format.html
      format.json { render json: @records, meta: { total: @records.size } }
    end
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

    return if @talk.to_public

    @talk = nil unless @authorized
  end

  def edit; end

  def update
    save_object(@talk, params[:users], params: talk_params)
  end

  def destroy
    destroy_object(@talk)
  end

  private

  def search_talks(search, my_talk, page)
    talks = if logged_in? && my_talk
              TalkQuery.new.owner(current_user)
            elsif search.blank?
              TalkQuery.new.publics
            else
              Kaminari.paginate_array(TalkQuery.new.search(search))
            end

    talks.page(page).per(12)
  end

  def set_talk
    @talk = Talk.find(params[:id])

    found = @talk && (@talk.owner == current_user || @talk.to_public)

    return if found

    redirect_to talks_path, notice: t('notice.not_found',
                                      model: t('mongoid.models.talk'))
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
                                 :tags, :video_link, :to_public, :thumbnail,
                                 :code)
  end
end
