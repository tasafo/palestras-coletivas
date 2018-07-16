#:nodoc:
class SchedulesController < ApplicationController
  before_action :require_logged_user, only: [:new, :create, :edit, :update]
  before_action :set_schedule, only: [:edit, :update, :destroy]

  def new
    @schedule = Schedule.new
    set_presenter
    @event_presenter = EventPresenter.new(@event, authorized_access?(@event), current_user)

    message = t('flash.unauthorized_access')

    redirect_to root_path, notice: message unless authorized_access?(@event)
  end

  def create
    @schedule = Schedule.new(schedule_params)

    set_presenter
    @event_presenter = EventPresenter.new(@event, authorized_access?(@event), current_user)

    save_schedule(:new, @event, @schedule, params)
  end

  def edit
    message = t('flash.unauthorized_access')

    redirect_to root_path, notice: message unless authorized_access?(@event)
  end

  def update
    save_schedule(:edit, @event, @schedule, params, schedule_params)
  end

  def destroy
    message = t('flash.unauthorized_access')

    redirect_to root_path, notice: message unless authorized_access?(@event)

    message = t('flash.schedules.destroy.notice')

    redirect_to new_event_schedule_path(@event, @schedule), notice: message if @schedule.destroy
  end

  private

  def set_schedule
    @schedule = Schedule.find(params[:id])

    set_presenter
  end

  def set_presenter
    @event = Event.find(params[:event_id])

    @schedule_presenter = SchedulePresenter.new(@schedule, @event)
  end

  def schedule_params
    params.require(:schedule).permit(:event_id, :activity_id, :talk_id,
                                     :day, :time, :environment)
  end

  def save_schedule(option, event, schedule, fields, params = nil)
    act = option == :new ? :create : :update

    object = ScheduleDecorator.new(schedule, fields['old_talk_id'],
                                   fields['schedule']['talk_id'], params)

    if object.send act
      message = t("flash.schedules.#{act}.notice")

      redirect_to new_event_schedule_path(event), notice: message
    else
      render option
    end
  end
end
