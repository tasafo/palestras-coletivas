class SchedulesController < ApplicationController
  before_filter :require_logged_user, :only => [:new, :create, :edit, :update]

  def new
    @schedule = Schedule.new

    auxiliary_objetcs

    redirect_to root_path, :notice => t("flash.unauthorized_access") unless authorized_access?(@event)
  end

  def create
    @schedule = Schedule.new(params[:schedule])

    auxiliary_objetcs

    if @schedule.save
      @schedule.update_counter_of_users_talks params[:old_talk_id], params[:talk_id]

      redirect_to event_path(@event), :notice => t("flash.schedules.create.notice")
    else
      render :new
    end
  end

  def edit
    @schedule = Schedule.find(params[:id])

    auxiliary_objetcs

    redirect_to root_path, :notice => t("flash.unauthorized_access") unless authorized_access?(@event)
  end

  def update
    @schedule = Schedule.find(params[:id])

    auxiliary_objetcs

    if @schedule.update_attributes(params[:schedule])
      @schedule.update_counter_of_users_talks params[:old_talk_id], params[:talk_id]

      redirect_to event_path(@event), :notice => t("flash.schedules.update.notice")
    else
      render :edit
    end
  end

  def search_talks
    search = params[:search]
    
    unless search.blank?
      @talks = Talk.fulltext_search(search, :index => 'fulltext_index_talks', :published => [ true ])
    end

    respond_to do |format|
      format.json { render :json => @talks }
    end
  end

  def add_vote
    @event = Event.find(params[:event_id])

    @schedule = Schedule.find(params[:id])

    begin
      @vote = Vote.create(:schedule => @schedule, :user => current_user)

      @schedule.set_counter(:votes, :inc)
    rescue

    end

    redirect_to "/events/#{@event._slugs[0]}#schedule", :notice => t("flash.schedules.vote.add")
  end

  def remove_vote
    @event = Event.find(params[:event_id])

    @schedule = Schedule.find(params[:id])

    begin
      @vote = Vote.find_by(:schedule => @schedule, :user => current_user)
      @vote.destroy

      @schedule.set_counter(:votes, :dec)
    rescue

    end

    redirect_to "/events/#{@event._slugs[0]}#schedule", :notice => t("flash.schedules.vote.remove")
  end

private
  def auxiliary_objetcs
    @event = Event.find(params[:event_id])
    
    @activities = Activity.all.order_by(:order => :asc)

    event_dates = (@event.start_date..@event.end_date).to_a

    @dates = ""
    day = 1
    event_dates.each do |date|
      selected = @schedule.day == day ? "selected='selected'" : ""

      @dates += "<option value='#{day}' #{selected}>#{date}</option>"
      day += 1
    end

    @talk_title = @schedule.talk? ? @schedule.talk.title : ""

    @display = @schedule.talk? ? "block" : "none"
  end
end