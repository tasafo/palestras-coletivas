class EventsController < PersistenceController
  before_action :require_logged_user, only: [:new, :create, :edit, :update]
  before_action :set_event, only: [:show, :edit, :update]
  before_action :set_organizers, only: [:new, :create, :edit, :update]

  def index
    @my = !params[:my].nil?

    @events = (logged_in? && @my) ? current_user.events.desc(:created_at) : EventQuery.new.all_public

    @events = @events.page(params[:page]).per(12)

    respond_to do |format|
      format.html
      format.json {
        render json: EventQuery.new.all_public.only('name', 'edition', 'description', 'start_date', 'end_date', 'street', 'district', 'state', 'country')
      }
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
    @presenter = EventPresenter.new(@event, authorized_access?(@event), current_user)

    render layout: 'event'
  end

  def edit
    redirect_to events_path, notice: t("flash.unauthorized_access") unless authorized_access?(@event)
  end

  def update
    save_object(@event, params[:users], params: event_params)
  end

  def presence
    event = Event.find params[:event_id]

    result = current_user.arrived_at event

    respond_to do |format|
      format.json { render json: { success: result } }
    end
  end

private

  def set_event
    @event = Event.find(params[:id])
  end

  def set_organizers
    @organizers = UserQuery.new.without_the_owner current_user
  end

  def event_params
    params.require(:event).permit(
      :name,
      :edition,
      :description,
      :thumbnail,
      :stocking,
      :tags,
      :start_date,
      :end_date,
      :deadline_date_enrollment,
      :accepts_submissions,
      :to_public,
      :place,
      :street,
      :district,
      :city,
      :state,
      :country
    )
  end
end
