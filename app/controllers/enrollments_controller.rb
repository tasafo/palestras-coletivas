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
    @enrollment = Enrollment.new(enrollment_params)
    @event = Event.find(params[:enrollment][:event_id])

    save_enrollment(operation: :create, event: @event, enrollment: @enrollment,
                    option_type: 'active', params: nil)
  end

  def edit
    @option_type = params[:option_type]

    @presenter = EnrollmentPresenter.new(
      enrollment: @enrollment, option_type: @option_type,
      authorized_edit: authorized_access?(@event), user: current_user
    )

    return if @presenter.can_record_presence

    redirect_to event_path(@event), notice: t('flash.unauthorized_access')
  end

  def update
    @option_type = params[:option_type]

    save_enrollment(operation: :update, event: @event, enrollment: @enrollment,
                    option_type: @option_type, params: enrollment_params)
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

  def save_enrollment(options = {})
    result = EnrollmentDecorator.new(
      options[:enrollment],
      options[:option_type],
      options[:params]
    ).send options[:operation]

    message_type = result ? 'notice' : 'error'

    notice = "flash.enrollments.#{options[:operation]}.#{message_type}"

    redirect_to event_path(options[:event]), notice: t(notice)
  end
end
