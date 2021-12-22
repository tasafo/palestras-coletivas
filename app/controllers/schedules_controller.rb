class SchedulesController < ApplicationController
  before_action :require_logged_user, only: %i[new create edit update]
  before_action :set_schedule, only: %i[edit update destroy]

  def new
    @schedule = Schedule.new

    set_presenter

    redirect_to_root_path(t('flash.unauthorized_access'))
  end

  def create
    @schedule = Schedule.new(schedule_params)

    set_presenter

    save_schedule(operation: :new, event: @event, schedule: @schedule,
                  fields: params, params: nil)
  end

  def edit
    redirect_to_root_path(t('flash.unauthorized_access'))
  end

  def update
    save_schedule(operation: :edit, event: @event, schedule: @schedule,
                  fields: params, params: schedule_params)
  end

  def destroy
    redirect_to_root_path(t('flash.unauthorized_access'))

    message = t('flash.schedules.destroy.notice')

    redirect_to event_path(@event), notice: message if @schedule.destroy
  end

  private

  def set_schedule
    @schedule = Schedule.find(params[:id])

    set_presenter
  end

  def set_presenter
    @event = Event.find(params[:event_id])

    @presenter = SchedulePresenter.new(@schedule, @event)
  end

  def schedule_params
    params.require(:schedule).permit(:event_id, :activity_id, :talk_id,
                                     :day, :time, :environment)
  end

  def redirect_to_root_path(message)
    redirect_to root_path, notice: message unless authorized_access?(@event)
  end

  def save_schedule(options = {})
    operation = options[:operation]
    act = operation == :new ? :create : :update

    object = decorate_schedule(options)

    if object.send act
      message = t("flash.schedules.#{act}.notice")

      redirect_to event_path(options[:event]), notice: message
    else
      render operation
    end
  end

  def decorate_schedule(options)
    fields = options[:fields]

    ScheduleDecorator.new(
      options[:schedule], fields['old_talk_id'],
      fields['schedule']['talk_id'], options[:params]
    )
  end
end
