class EnrollmentsController < ApplicationController
  before_action :require_logged_user, only: [:new, :create, :edit, :update]
  before_action :set_enrollment, only: [:edit, :update]
  before_action :set_event, only: [:new, :edit, :update]

  def new
    @enrollment = Enrollment.new
    @presenter = EnrollmentPresenter.new(user: current_user)
  end

  def create
    @enrollment = Enrollment.new(enrollment_params)
    @event = Event.find(params[:enrollment][:event_id])
    message = "error"

    if @enrollment.save
      @enrollment.update_counter_of_events_and_users "active"
      message = "notice"
    end

    redirect_to event_path(@event), :notice => t("flash.enrollments.create.#{message}")
  end

  def edit
    @option_type = params[:option_type]

    @presenter = EnrollmentPresenter.new(
      event: @event,
      enrollment: @enrollment,
      option_type: @option_type,
      authorized_edit: authorized_access?(@event),
      user: current_user
    )

    redirect_to event_path(@event), :notice => t("flash.unauthorized_access") unless @presenter.can_record_presence
  end

  def update
    @option_type = params[:option_type]

    if @enrollment.update_attributes(enrollment_params)
      @enrollment.update_counter_of_events_and_users @option_type

      redirect_to event_path(@event), :notice => t("flash.enrollments.update.notice")
    end
  end

private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_enrollment
    @enrollment = Enrollment.find(params[:id])
  end

  def enrollment_params
    params.require(:enrollment).permit(:event_id, :user_id, :active, :present)
  end
end