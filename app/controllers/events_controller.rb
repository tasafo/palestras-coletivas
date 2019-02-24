#:nodoc:
class EventsController < PersistenceController
  before_action :require_logged_user, only: %i[new create edit update]
  before_action :set_event, only: %i[show edit update destroy]
  before_action :set_organizers, only: %i[new create edit update]
  before_action :check_authorization, only: %i[edit destroy]

  def index
    @my_event = !params[:my].blank?

    @events = query_event(@my_event)
    @events = @events.page(params[:page]).per(12)

    respond_to do |format|
      format.html
      format.json { render json: @events, meta: { total: @events.size } }
    end
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)

    save_object(@event, params[:users], owner: current_user)
  end

  def show
    @presenter = EventPresenter.new(@event,
                                    authorized_access?(@event), current_user)

    render layout: 'event'
  end

  def edit; end

  def update
    save_object(@event, params[:users], params: event_params)
  end

  def destroy
    destroy_object(@event)
  end

  private

  def set_event
    @event = Event.with_relations.find(params[:id])

    found = !@event.nil? && (@event.owner == current_user || @event.to_public)

    return if found

    redirect_to events_path, notice: t('notice.not_found',
                                       model: t('mongoid.models.event'))
  end

  def set_organizers
    @organizers = UserQuery.new.without_the_owner current_user
  end

  def check_authorization
    return if authorized_access?(@event)

    redirect_to events_path, notice: t('flash.unauthorized_access')
  end

  def query_event(my_event)
    if logged_in? && my_event
      EventQuery.new.owner(current_user)
    else
      EventQuery.new.all_public
    end
  end

  def event_params
    params.require(:event).permit(
      :name, :edition, :description, :stocking, :tags, :start_date,
      :end_date, :deadline_date_enrollment, :accepts_submissions, :to_public,
      :place, :street, :district, :city, :state, :country, :block_presence,
      :workload, :image, :remove_image
    )
  end
end
