#:nodoc:
class SchedulesController < ApplicationController
  before_action :require_logged_user, only: [:new, :create, :edit, :update]
  before_action :set_schedule, only: [:edit, :update, :destroy]

  def new
    @schedule = Schedule.new

    set_presenter

    message = t('flash.unauthorized_access')

    redirect_to root_path, notice: message unless authorized_access?(@event)
  end

  def create
    @schedule = Schedule.new(schedule_params)

    set_presenter

    save_schedule(operation: :new, event: @event, schedule: @schedule,
                  fields: params, params: nil)
  end

  def edit
    message = t('flash.unauthorized_access')

    redirect_to root_path, notice: message unless authorized_access?(@event)
  end

  def update
    save_schedule(operation: :edit, event: @event, schedule: @schedule,
                  fields: params, params: schedule_params)
  end

  def destroy
    message = t('flash.unauthorized_access')

    redirect_to root_path, notice: message unless authorized_access?(@event)

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

  def save_schedule(options = {})
    act = options[:operation] == :new ? :create : :update

    object = decorate_schedule(options)

    if object.send act
      message = t("flash.schedules.#{act}.notice")

      redirect_to event_path(options[:event]), notice: message
    else
      render options[:operation]
    end
  end

  def decorate_schedule(options)
    ScheduleDecorator.new(
      options[:schedule], options[:fields]['old_talk_id'],
      options[:fields]['schedule']['talk_id'], options[:params]
    )
  end
end
