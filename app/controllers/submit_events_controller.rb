class SubmitEventsController < ApplicationController
  before_action :require_logged_user, only: %i[new create]

  def new
    @schedule = Schedule.new
    @talk = Talk.find(params[:talk_id])
    @events = EventQuery.new.accepts_submissions
    @schedule_found = nil

    return unless @events.size <= 0

    redirect_to talk_path(@talk), alert: t('flash.submit_event.new.alert')
  end

  def create
    prepare_objects(params)

    message = if @schedule_found
                t('flash.submit_event.create.alert')
              else
                message_type = save_schedule ? 'notice' : 'error'

                t("flash.submit_event.create.#{message_type}")
              end

    redirect_to talk_path(@talk), notice: message
  end

  private

  def prepare_objects(params)
    @event = Event.find(params[:submit_event]['event_id'])
    @talk = Talk.find(params[:talk_id])
    @schedule_found = @event.schedules.find_by(talk_id: @talk.id)
  end

  def save_schedule
    @schedule = @event.schedules.new(talk: @talk, day: 1, time: @event.first_time,
                                     description: t('labels.schedule.talk'))
    @schedule.save
  end
end
