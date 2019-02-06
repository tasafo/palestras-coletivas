#:nodoc:
class EnrollmentsController < ApplicationController
  before_action :require_logged_user, only: [:new, :create, :edit, :update]
  before_action :set_enrollment, only: [:edit, :update]
  before_action :set_event, only: [:new, :edit, :update]

  def new
    @enrollment = Enrollment.new
    @presenter = EnrollmentPresenter.new(user: current_user)
  end

  def create
    @enrollment = Enrollment.new
    @event = Event.find(params[:event_id])
    @enrollment.event = @event
    @enrollment.user = current_user

    result = EnrollmentDecorator.new(
      @enrollment,
      :active
    ).create

    if result
      render json: { message: t("flash.enrollments.create.notice") }, status: :created
    else
      render json: { message: t("flash.enrollments.create.error") }, status: :unprocessable_entity
    end
  end

  def edit
    @option_type = params[:option_type]

    @presenter = EnrollmentPresenter.new(
      enrollment: @enrollment, option_type: @option_type,
      authorized_edit: authorized_access?(@event), user: current_user
    )

    message = t('flash.unauthorized_access')
    redirect_to event_path(@event),
                notice: message unless @presenter.can_record_presence
  end

  def update
    @option_type = params[:option_type]

    save_enrollment(:update, @event, @enrollment, @option_type,
                    enrollment_params)
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

  def save_enrollment(operation, event, enrollment, option_type, params = nil)
    result = EnrollmentDecorator.new(
      enrollment,
      option_type,
      params
    ).send operation

    message_type = result ? 'notice' : 'error'

    redirect_to event_path(event),
                notice: t("flash.enrollments.#{operation}.#{message_type}")
  end
end
