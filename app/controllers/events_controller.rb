#:nodoc:
class EventsController < PersistenceController
  before_action :require_logged_user, only: [:new, :create, :edit, :update]
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :set_organizers, only: [:new, :create, :edit, :update]
  before_action :check_authorization, only: [:edit, :destroy]

  def index
    @my = !params[:my].blank?

    @events = if logged_in? && @my
                EventQuery.new.owner(current_user)
              else
                EventQuery.new.all_public
              end
    @events = @events.page(params[:page]).per(6)

    render nothing: true, status: 404 if params[:page] && @events.blank?
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)

    save_object(@event, params[:users], owner: current_user)
  end

  def show
    @presenter = EventPresenter.new(@event, authorized_access?(@event),
      current_user)

    render layout: 'event'
  end

  def edit
  end

  def update
    save_object(@event, params[:users], params: event_params)
  end

  def destroy
    @event.destroy

    redirect_to events_path,
      notice: t('notice.destroyed', model: t('mongoid.models.event'))
  end

  def ajax
    @my = !params[:my].blank?

    @events = if logged_in? && @my
                EventQuery.new.owner(current_user)
              else
                EventQuery.new.all_public
              end
    @events = @events.page(params[:page]).per(12)

    render nothing: true, status: 404 if params[:page] && @events.blank?
  end

  private

  def set_event
    @event = Event.with_relations.find(params[:id])

    found = !@event.nil? && (@event.owner == current_user || @event.to_public)

    redirect_to events_path, notice: t("notice.not_found",
                  model: t("mongoid.models.event")) if !found
  end

  def set_organizers
    @organizers = UserQuery.new.without_the_owner current_user
  end

  def check_authorization
    redirect_to events_path,
      notice: t('flash.unauthorized_access') unless authorized_access?(@event)
  end

  def event_params
    params.require(:event).permit(
      :name, :edition, :description, :stocking, :tags, :start_date,
      :end_date, :deadline_date_enrollment, :accepts_submissions, :to_public,
      :place, :street, :district, :city, :state, :country, :block_presence,
      :workload, :image, :cover_id
    )
  end
end
