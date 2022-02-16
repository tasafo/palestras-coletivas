class PresencesController < ApplicationController
  before_action :require_logged_user, only: %i[new]
  before_action :set_event, only: %i[new create update]

  def new
    redirect_to event_path(@event)
  end

  def create
    result = current_user.arrived_at(@event)

    respond_to do |format|
      format.json { render json: { success: result } }
    end
  end

  def update
    user = User.find(params[:id])
    @enrollment = @event.enrollments.find_by(user: user)

    respond_to do |format|
      format.json { render json: upsert_presence }
    end
  end

  private

  def upsert_presence
    present = false
    result = false

    if @enrollment
      present = !@enrollment.present
      result = @enrollment.update(present: present)
    end

    { success: result, present: present }
  end

  def set_event
    @event = Event.find(params[:event_id])
  end
end
