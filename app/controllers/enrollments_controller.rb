class EnrollmentsController < ApplicationController
  def create
    @event = Event.find(params[:event_id])
    @enrollment = current_user.enrollments.find_by(event: @event)

    respond_to do |format|
      format.json { render json: upsert_enrollment }
    end
  end

  private

  def upsert_enrollment
    if @enrollment
      active = !@enrollment.active
      result = @enrollment.update(active: active, present: false)
    else
      active = true
      result = current_user.enroll_at(@event).valid?
    end

    { success: result, active: active }
  end
end
