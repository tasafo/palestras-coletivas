class VotesController < ApplicationController
  before_action :set_schedule, only: [:new, :create]

  def new
    if @event
      @vote = Vote.create(schedule: @schedule, user: current_user)

      @schedule.set_counter(:votes, :inc)
    end

    redirect_to "/events/#{@event._slugs[0]}#schedule",
      notice: t("flash.schedules.vote.add")
  end

  def create
    if @event
      @vote = Vote.find_by(schedule: @schedule, user: current_user)
      @vote.destroy

      @schedule.set_counter(:votes, :dec)

      redirect_to "/events/#{@event._slugs[0]}#schedule",
        notice: t("flash.schedules.vote.remove")
    end
  end

private

  def set_schedule
  	@event = Event.find(params[:event_id])
    @schedule = Schedule.find(params[:schedule_id])
  end
end
