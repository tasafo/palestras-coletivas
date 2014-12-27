class EventsController < ApplicationController
  before_filter :require_logged_user, :only => [:new, :create, :edit, :update]
  before_action :set_event, only: [:show, :edit, :update]

  def index
    @my = !params[:my].nil?

    @events = EventQuery.new.all_public unless @my

    @events = current_user.events.desc(:start_date) if logged_in? && @my

    respond_to do |format|
      format.html
      format.json {
        render json: EventQuery.new.all_public.only('name', 'edition', 'description', 'start_date', 'end_date', 'street', 'district', 'state', 'country')
      }
    end
  end

  def new
    @event = Event.new
    @organizers = User.without_the_owner current_user
  end

  def create
    @event = Event.new(event_params)
    @organizers = User.without_the_owner current_user

    save_event(:new, @event, params[:users], owner: current_user)
  end

  def show
    user = current_user ? current_user : nil
    
    @presenter = EventPresenter.new(@event, user, authorized_access?(@event))

    render layout: 'event'
  end

  def edit
    @organizers = User.without_the_owner current_user

    redirect_to events_path, :notice => t("flash.unauthorized_access") unless authorized_access?(@event)
  end

  def update
    @organizers = User.without_the_owner current_user

    save_event(:edit, @event, params[:users], params: event_params)
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

    def event_params
      params.require(:event).permit(
        :name, :edition, :description, :stocking, :tags, :start_date, :end_date, :deadline_date_enrollment, 
        :accepts_submissions, :to_public, :place, :street, :district, :city, :state, :country
      )
    end

    def save_event(option, event, users, args = {})
      operation = option == :new ? 'create' : 'update'

      if eval("EventService.new(event, users, owner: args[:owner], params: args[:params]).#{operation}")
        redirect_to event_path(event), :notice => t("flash.events.#{operation}.notice")
      else
        render option
      end
    end
end
