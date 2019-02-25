#:nodoc:
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

    if @_schedule.nil?
      new_schedule

      message = t("flash.submit_event.create.#{save_schedule}")
    else
      message = t('flash.submit_event.create.alert')
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
                             day: 1, time: time(@event))
  end

  def save_schedule
    @schedule.save ? 'notice' : 'error'
  end

  def time(event)
    schedules = event.schedules.asc(:time)

    time = schedules.empty? ? '00:00' : schedules.first.time

    if time != '00:00'
      hours = time.split(':')[0]
      minutes = time.split(':')[1].to_i + 1
      time = format("#{hours}:%02d", minutes.to_s)
    end

    time
  end
end
