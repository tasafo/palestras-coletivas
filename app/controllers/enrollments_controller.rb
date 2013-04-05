class EnrollmentsController < ApplicationController
  before_filter :require_logged_user, :only => [:new, :create, :edit, :update]

  def new
    @enrollment = Enrollment.new
    @event = Event.find(params[:event_id])
  end

  def create
    @enrollment = Enrollment.new(params[:enrollment])
    @event = Event.find(params[:enrollment][:event_id])

    if @enrollment.save
      @enrollment.update_counter_of_events_and_users

      redirect_to event_path(@event), :notice => t("flash.enrollments.create.notice")
    end
  end

  def edit
    @enrollment = Enrollment.find(params[:id])
    @event = Event.find(params[:event_id])

    if @enrollment.active?
      @message_type = "text-warning"
      @active = false
      @message_button = t("show.event.cancel_my_participation")
    else
      @message_type = "text-success"
      @active = true
      @message_button = t("show.event.participate")
    end
  end

  def update
    @enrollment = Enrollment.find(params[:id])
    @event = Event.find(params[:event_id])

    if @enrollment.update_attributes(params[:enrollment])
      @enrollment.update_counter_of_events_and_users

      redirect_to event_path(@event), :notice => t("flash.enrollments.update.notice")
    end
  end
end