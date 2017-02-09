#:nodoc:
class VotesController < ApplicationController
  before_action :set_objects, only: [:create, :destroy]

  def create
    unless @vote
      @vote = current_user.votes.create(schedule: @schedule)
      @schedule.set_counter(:votes, :inc)
      @notice = 'add'
    end

    redirect_to_event
  end

  def destroy
    if @vote
      @vote.destroy
      @schedule.set_counter(:votes, :dec)
      @notice = 'remove'
    end

    redirect_to_event
  end

  private

  def set_objects
    @event = Event.find(params.merge(only_path: true)[:event_id])
    @schedule = Schedule.find(params[:schedule_id])
    @vote = current_user.votes.find_by(schedule: @schedule)
    @notice = 'was_not_held'

    redirect_to event_path(@event, anchor: 'schedule') and return unless @event
  end

  def redirect_to_event
    redirect_to event_path(@event, anchor: 'schedule'), notice: t("flash.schedules.vote.#{@notice}")
  end
end
