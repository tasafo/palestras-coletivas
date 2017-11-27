#:nodoc:
class EventsController < PersistenceController
  before_action :require_logged_user, only: [:new, :create, :edit, :update]
  before_action :set_event, only: [:show, :edit, :update]
  before_action :set_organizers, only: [:new, :create, :edit, :update]

  def index
    @my = !params[:my].nil?

    @events = if logged_in? && @my
                current_user.events.desc(:created_at)
              else
                EventQuery.new.all_public
              end
    @events = @events.page(params[:page]).per(12)
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
    @certifico_url = ENV['CERTIFICO_URL']

    render layout: 'event'
  end

  def edit
    message = t('flash.unauthorized_access')

    redirect_to events_path, notice: message unless authorized_access?(@event)
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
      :name, :edition, :description, :stocking, :tags, :start_date,
      :end_date, :deadline_date_enrollment, :accepts_submissions, :to_public,
      :place, :street, :district, :city, :state, :country, :block_presence,
      :workload, :issue_certificates, :image, :remove_image
    )
  end
end
