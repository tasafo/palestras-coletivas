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

    if EventService.new(@event, params[:users], owner: current_user).save
      redirect_to event_path(@event), :notice => t("flash.events.create.notice")
    else
      render :new
    end
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

    if EventService.new(@event, params[:users], params: event_params).update
      redirect_to event_path(@event), :notice => t("flash.events.update.notice")
    else
      render :edit
    end
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
end
