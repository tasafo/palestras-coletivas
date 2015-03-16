class SubmitEventsController < ApplicationController
  before_action :require_logged_user, only: [:new, :create]

  def new
    @schedule = Schedule.new
    @talk = Talk.find(params[:talk_id])
    @events = EventQuery.new.accepts_submissions

    if @events.count <= 0
      redirect_to talk_path(@talk), :alert => t("flash.submit_event.new.alert")
    end
  end

  def create
    @error = false

    @event = Event.find(params[:submit_event]['event_id'])
    @talk = Talk.find_by(_slugs: params[:talk_id])
    @activity = Activity.find_by(type: "talk")
    @_schedule = Schedule.find_by(event_id: @event.id, talk_id: @talk.id)

    if @_schedule.nil?
      @schedule = Schedule.new(activity: @activity, event: @event, talk: @talk, day: 1, time: '00:00')

      if @schedule.save
        @error = true
        @message = t("flash.submit_event.create.notice")
      end
    else
      @error = true
      @message = t("flash.submit_event.create.alert")
    end

    redirect_to talk_path(@talk), :notice => @message if @error
  end
end