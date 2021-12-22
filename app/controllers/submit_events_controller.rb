class SubmitEventsController < ApplicationController
  before_action :require_logged_user, only: %i[new create]

  def new
    @schedule = Schedule.new
    @talk = Talk.find(params[:talk_id])
    @events = EventQuery.new.accepts_submissions
    @_schedule = nil

    return unless @events.size <= 0

    redirect_to talk_path(@talk), alert: t('flash.submit_event.new.alert')
  end

  def create
    prepare_objects(params)

    if @_schedule
      message = t('flash.submit_event.create.alert')
    else
      new_schedule

      message = t("flash.submit_event.create.#{save_schedule}")
    end

    redirect_to talk_path(@talk), notice: message if message
  end

  private

  def prepare_objects(params)
    @event = Event.find(params[:submit_event]['event_id'])
    @talk = Talk.find_by(_slugs: params[:talk_id])
    @activity = Activity.find_by(type: 'talk')
    @_schedule = Schedule.find_by(event_id: @event.id, talk_id: @talk.id)
  end

  def new_schedule
    @schedule = Schedule.new(activity: @activity, event: @event, talk: @talk,
                             day: 1, time: @event.first_time)
  end

  def save_schedule
    @schedule.save ? 'notice' : 'error'
  end
end
