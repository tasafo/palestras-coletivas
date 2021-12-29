class EventsController < ApplicationController
  before_action :require_logged_user, only: %i[new create edit update]
  before_action :set_event, only: %i[show edit update destroy]
  before_action :set_organizers, only: %i[new create edit update]
  before_action :check_authorization, only: %i[edit destroy]

  def index
    @my_events = params[:my]
    query = query_event(@my_events)
    @pagy, @records = pagy(query, count: query.count)

    respond_to do |format|
      format.html
      format.json { render jsonapi: @records, meta: { total: @records.size } }
    end
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)

    event_decorator = EventDecorator.new(@event, params[:users], owner: current_user)

    if event_decorator.create
      redirect_to event_path(@event), notice: t('flash.events.create.notice')
    else
      render :new
    end
  end

  def show
    @presenter = EventPresenter.new(@event, authorized_access?(@event), current_user)

    render layout: 'event'
  end

  def edit; end

  def update
    @event.destroy_image if event_params[:image] || event_params[:remove_image] == '1'

    event_decorator = EventDecorator.new(@event, params[:users], params: event_params)

    if event_decorator.update
      redirect_to event_path(@event), notice: t('flash.events.update.notice')
    else
      render :edit
    end
  end

  def destroy
    @event.destroy_image

    if @event.destroy
      redirect_to events_path, notice: t('notice.destroyed', model: t('mongoid.models.event'))
    else
      redirect_to event_path(@event), notice: t('notice.delete.restriction.events')
    end
  end

  private

  def set_event
    @event = Event.with_relations.find(params[:id])

    found = @event && (@event.owner == current_user || @event.to_public)

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

  def query_event(my_events)
    if logged_in? && !my_events.blank?
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
      :workload, :image, :remove_image, :online
    )
  end
end
