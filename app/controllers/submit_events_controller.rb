class SubmitEventsController < ApplicationController
  before_filter :require_logged_user, :only => [:new, :create]

  def new
    @schedule = Schedule.new
    @talk = Talk.find(params[:talk_id])
    @events = Event.where(:to_public => true, :accepts_submissions => true, :end_date.gte => Date.today).order_by(:start_date => :desc)

    if @events.count <= 0
      redirect_to talk_path(@talk), :alert => t("flash.submit_event.new.alert")
    end
  end

  def create
    @error = false

    @event = Event.find(params[:submit_event]['event_id'])

    @talk = Talk.find_by(_slugs: params[:talk_id])

    @activity = Activity.find_by(description: "Trabalho")
    
    begin
      @_schedule = Schedule.find_by(event_id: @event.id, talk_id: @talk.id)

      @error = true
      @message = t("flash.submit_event.create.alert")

    rescue Mongoid::Errors::DocumentNotFound
      @schedule = Schedule.new(
        activity: @activity,
        event: @event,
        talk: @talk,
        day: 1,
        time: '00:00'
      )

      if @schedule.save
        @error = true
        @message = t("flash.submit_event.create.notice")
      end
    
    end

    redirect_to talk_path(@talk), :notice => @message if @error
  end
end