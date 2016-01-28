class SchedulesController < ApplicationController
  before_action :require_logged_user, only: [:new, :create, :edit, :update]
  before_action :set_schedule, only: [:edit, :update, :destroy]

  def new
    @schedule = Schedule.new

    set_presenter

    redirect_to root_path,
      notice: t("flash.unauthorized_access") unless authorized_access?(@event)
  end

  def create
    @schedule = Schedule.new(schedule_params)

    set_presenter

    save_schedule(:new, @event, @schedule, params[:old_talk_id],
      params[:talk_id])
  end

  def edit
    redirect_to root_path,
      notice: t("flash.unauthorized_access") unless authorized_access?(@event)
  end

  def update
    save_schedule(:edit, @event, @schedule, params[:old_talk_id],
      params[:talk_id], schedule_params)
  end

  def destroy
    redirect_to root_path,
      notice: t("flash.unauthorized_access") unless authorized_access?(@event)

    redirect_to event_path(@event),
      notice: t("flash.schedules.destroy.notice") if @schedule.destroy
  end

  def search_talks
    @talks = TalkQuery.new.search(params[:search]) unless params[:search].blank?

    respond_to do |format|
      format.json {
        render json: @talks.only('_id', 'thumbnail', '_slugs', 'title',
          'description', 'tags')
      }
    end
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
    params.require(:schedule).permit(
      :event_id,
      :activity_id,
      :talk_id,
      :day,
      :time,
      :environment
    )
  end

  def save_schedule(option, event, schedule, old_talk_id, talk_id, params=nil)
    act = option == :new ? :create : :update

    if ScheduleDecorator.new(schedule, old_talk_id, talk_id, params).send act
      redirect_to event_path(event),
        notice: t("flash.schedules.#{act.to_s}.notice")
    else
      render option
    end
  end
end
