class EventPolicy
  def initialize(event)
    @event = event
  end

  def address
    [@event.street, @event.district, @event.city, @event.state, @event.country]
      .compact.join(', ')
  end

  def in_progress?
    (@event.start_date..@event.end_date).cover?(Date.today)
  end
end
