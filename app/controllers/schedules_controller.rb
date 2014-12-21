class SchedulesController < ApplicationController
  before_filter :require_logged_user, :only => [:new, :create, :edit, :update]
  before_action :set_schedule, only: [:edit, :update, :add_vote, :remove_vote]

  def new
    @schedule = Schedule.new

    set_objetcs

    redirect_to root_path, :notice => t("flash.unauthorized_access") unless authorized_access?(@event)
  end

  def create
    @schedule = Schedule.new(schedule_params)

    set_objetcs

    if @schedule.save
      @schedule.update_counter_of_users_talks params[:old_talk_id], params[:talk_id]

      redirect_to event_path(@event), :notice => t("flash.schedules.create.notice")
    else
      render :new
    end
  end

  def edit
    set_objetcs

    redirect_to root_path, :notice => t("flash.unauthorized_access") unless authorized_access?(@event)
  end

  def update
    set_objetcs

    if @schedule.update_attributes(schedule_params)
      @schedule.update_counter_of_users_talks params[:old_talk_id], params[:talk_id]

      redirect_to event_path(@event), :notice => t("flash.schedules.update.notice")
    else
      render :edit
    end
  end

  def search_talks
    @talks = Talk.search(params[:search]) unless params[:search].blank?

    respond_to do |format|
      format.json { render :json => @talks.only('_id', 'thumbnail', '_slugs', 'title', 'description', 'tags') }
    end
  end

  def add_vote
    @event = Event.find(params[:event_id])

    if @event
      @vote = Vote.create(:schedule => @schedule, :user => current_user)

      @schedule.set_counter(:votes, :inc)
    end

    redirect_to "/events/#{@event._slugs[0]}#schedule", :notice => t("flash.schedules.vote.add")
  end

  def remove_vote
    @event = Event.find(params[:event_id])

    if @event
      @vote = Vote.find_by(:schedule => @schedule, :user => current_user)
      @vote.destroy

      @schedule.set_counter(:votes, :dec)

      redirect_to "/events/#{@event._slugs[0]}#schedule", :notice => t("flash.schedules.vote.remove")
    end
  end

  private
    def set_schedule
      @schedule = Schedule.find(params[:id])
    end

    def schedule_params
      params.require(:schedule).permit(:event_id, :activity_id, :talk_id, :day, :time, :environment)
    end

    def set_objetcs
      @event = Event.find(params[:event_id])

      @activities = Activity.all.order_by(:order => :asc)

      event_dates = (@event.start_date..@event.end_date).to_a

      @dates, day = "", 1
      event_dates.each do |date|
        selected = @schedule.day == day ? "selected='selected'" : ""

        @dates += "<option value='#{day}' #{selected}>#{date}</option>"
        day += 1
      end

      @talk_title = @schedule.talk? ? @schedule.talk.title : ""

      @display = @schedule.talk? ? "block" : "none"
    end
end