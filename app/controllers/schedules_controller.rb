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
      @schedule.update_users_counter params[:old_talk_id], params[:talk_id]

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
      @schedule.update_users_counter params[:old_talk_id], params[:talk_id]

      redirect_to event_path(@event), :notice => t("flash.schedules.update.notice")
    else
      render :edit
    end
  end

  def search_talks
    result = nil
    search = params[:search]
    
    unless search.blank?
      @talks = Talk.fulltext_search(search, :index => 'fulltext_index_talks', :published => [ true ])

      result = render_to_string(
        :partial => "shared/talks_found",
        :layout => false
      )
    end

    respond_to do |format|
      format.json { render :json => { :result => result } }
    end
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