class SchedulesController < ApplicationController
  before_filter :require_logged_user, :only => [:new, :create, :edit, :update]

  def new
    @schedule = Schedule.new

    auxiliary_objetcs

    redirect_to root_path, :notice => t("flash.unauthorized_access") unless authorized_access?(@event)
  end

  def create
    @schedule = Schedule.new(params[:schedule])

    auxiliary_objetcs

    if @schedule.save
      redirect_to event_path(@event), :notice => t("flash.schedules.create.notice")
    else
      render :new
    end
  end

  def edit
    @schedule = Schedule.find(params[:id])

    auxiliary_objetcs

    redirect_to root_path, :notice => t("flash.unauthorized_access") unless authorized_access?(@event)
  end

  def update
    @schedule = Schedule.find(params[:id])

    auxiliary_objetcs

    if @schedule.update_attributes(params[:schedule])
      redirect_to event_path(@event), :notice => t("flash.schedules.update.notice")
    else
      render :edit
    end
  end

private
  def auxiliary_objetcs
    @event = Event.find(params[:event_id])
    @sessions = Session.all.order_by(:order => :asc)
    @dates = (@event.start_date..@event.end_date).to_a
  end
end