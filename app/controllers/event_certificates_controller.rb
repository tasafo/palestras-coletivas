#:nodoc:
class EventCertificatesController < PersistenceController
  before_action :set_event, only: [:speakers, :organizers, :participants]

  def speakers

  end

  def organizers

  end

  def participants
    case params[:kind]
    when 'attendees'
      @enrollments = @event.enrollments.presents
    when 'user'
      @enrollments = @event.enrollments.where(user: params[:user_id])
    else
      @enrollments = @event.enrollments.actives
    end
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end
end
