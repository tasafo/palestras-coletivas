class TalksController < PersistenceController
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

    save_object(@talk, params[:users], owner: current_user)
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
    redirect_to talks_path, :notice => t("flash.unauthorized_access") unless authorized_access?(@talk)
  end

  def update
    save_object(@talk, params[:users], params: talk_params)
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
    if logged_in? && my
      talks = current_user.talks.desc(:created_at)
    else
      talks = search.blank? ? TalkQuery.new.publics : Kaminari.paginate_array(TalkQuery.new.search(search))
    end

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
