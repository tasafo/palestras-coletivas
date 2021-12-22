class WasPresentedsController < ApplicationController
  def create
    @event = Event.find(params.merge(only_path: true)[:event_id])

    @schedule = Schedule.find(params[:schedule_id])

    @schedule.update(was_presented: !@schedule.was_presented)

    redirect_to event_path(@event, anchor: 'schedule')
  end
end
