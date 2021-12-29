class EnrollmentsController < ApplicationController
  before_action :require_logged_user, only: %i[new create edit update]
  before_action :set_enrollment, only: %i[edit update]
  before_action :set_event, only: %i[new edit update]

  def new
    @enrollment = Enrollment.new
    @presenter = EnrollmentPresenter.new(user: current_user)
  end

  def create
    @enrollment = Enrollment.new(enrollment_params)
    @event = Event.find(params[:enrollment][:event_id])

    message = @enrollment.upsert(operation: :create, option_type: 'active', params: nil)

    redirect_to event_path(@event), notice: t(message)
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

    message = @enrollment.upsert(operation: :update, option_type: @option_type,
                                 params: enrollment_params)

    redirect_to event_path(@event), notice: t(message)
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
