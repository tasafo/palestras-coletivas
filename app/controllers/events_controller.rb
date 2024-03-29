class EventsController < ApplicationController
  before_action :require_logged_user, only: %i[new create edit update]
  before_action :set_event, only: %i[show edit update destroy]
  before_action :set_organizers, only: %i[new create edit update]
  before_action :check_authorization, only: %i[edit destroy]

  def index
    query = EventQuery.new.select(current_user, params[:search], params[:my]).to_a
    @pagy, @records = pagy(query, count: query.count)

    respond_to do |format|
      format.html
      format.json { render jsonapi: @records, meta: { total: @records.size } }
    end
  end

  def new
    @event = Event.new
    @event.address_from_ip(request.remote_ip)
  end

  def create
    @event = Event.new(event_params.to_h.merge({ owner: current_user }))

    render :new and return if @event.invalid?

    attributes = prepare_attributes(current_user, :create, event_params)

    @event = Event.create(attributes)

    redirect_to event_path(@event, anchor: 'page-content'), notice: t('flash.events.create.notice') if @event
  end

  def show
    @presenter = EventPresenter.new(@event, authorized_access?(@event), current_user)

    render layout: 'event'
  end

  def edit
    @event.start_date = I18n.l(@event.start_date)
    @event.end_date = I18n.l(@event.end_date)
    @event.deadline_date_enrollment = I18n.l(@event.deadline_date_enrollment)
  end

  def update
    remove_existing_image

    @event.refresh(event_params)

    render :edit and return if @event.invalid?

    saved = @event.update(prepare_attributes(@event.owner, :update, event_params))

    redirect_to event_path(@event, anchor: 'page-content'), notice: t('flash.events.update.notice') if saved
  end

  def destroy
    @event.destroy_image

    if @event.destroy
      redirect_to events_path, notice: t('notice.destroyed', model: t('mongoid.models.event'))
    else
      redirect_to event_path(@event, anchor: 'page-content'), notice: t('notice.delete.restriction.events')
    end
  end

  private

  def set_event
    @event = Event.with_relations.find(params[:id])

    found = @event && (@event.owner == current_user || @event.to_public)

    return if found

    redirect_to events_path, notice: t('notice.not_found', model: t('mongoid.models.event'))
  end

  def set_organizers
    @organizers = UserQuery.new.without_the_owner current_user
  end

  def check_authorization
    return if authorized_access?(@event)

    redirect_to events_path, notice: t('flash.unauthorized_access')
  end

  def event_params
    params.require(:event).permit(
      :name, :description, :stocking, :tags, :start_date,
      :end_date, :deadline_date_enrollment, :accepts_submissions, :to_public,
      :place, :street, :district, :city, :state, :country, :block_presence,
      :workload, :image, :remove_image, :online
    )
  end

  def remove_existing_image
    @event.destroy_image if event_params[:image] || event_params[:remove_image] == '1'
  end
end
