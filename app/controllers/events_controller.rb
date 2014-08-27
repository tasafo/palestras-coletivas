class EventsController < ApplicationController
  before_filter :require_logged_user, :only => [:new, :create, :edit, :update]

  def index
    if params[:my].nil?
      @events = Event.all_public
      @my = false
    else
      @events = current_user.events.order_by(:start_date => :desc) if logged_in?
      @my = true
    end

    respond_to do |format|
      format.html
      format.json {
        render json: Event.all_public.only('name', 'edition', 'description', 'start_date', 'days', 'street', 'district', 'state', 'country')
      }
    end
  end

  def new
    @event = Event.new
    @organizers = User.without_the_owner current_user
    @groups = Group.by_name
  end

  def create
    @event = Event.new(params[:event])

    @event.owner = current_user.id

    @organizers = User.without_the_owner current_user
    @groups = Group.by_name

    if @event.save
      @event.update_list_organizers current_user, params[:users]

      @event.update_list_groups params[:groups]

      redirect_to event_path(@event), :notice => t("flash.events.create.notice")
    else
      render :new
    end
  end

  def show
    begin
      @event = Event.find(params[:id])
      @dates = (@event.start_date..@event.end_date).to_a
      @authorized = authorized_access?(@event)

      @open_enrollment = @event.deadline_date_enrollment >= Date.today

      @can_record_presence = @authorized && Date.today >= @event.start_date

      @show_users_present = Date.today > @event.end_date && !@can_record_presence

      @users_present = []
      @event.enrollments.presents.each { |e| @users_present << e.user }
      @users_present.sort_by! { |u| u._slugs }

      @users_active = []
      @event.enrollments.actives.each { |e| @users_active << { :name => e.user._slugs, :enrollment => e } }
      @users_active.sort_by! { |h| h[:name] }

      @crowded = @users_active.count >= @event.stocking

      @new_subscription = true

      if logged_in?
        @enrollment = Enrollment.where(:event => @event, :user => current_user).first

        @new_subscription = false if @enrollment

        @the_user_is_speaker = false

        @event.schedules.each do |schedule|
          if schedule.talk?
            schedule.talk.users.each do |user|
              @the_user_is_speaker = true if user.id == current_user.id
            end
          end
        end

        @open_enrollment = false if @the_user_is_speaker || @authorized
      end

      unless @event.to_public
        @event = nil unless @authorized
      end

      @image_top = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'].sample

      @can_vote = @event && @event.accepts_dynamic_programming && @event.end_date >= Date.today

      render layout: 'event'

    rescue Mongoid::Errors::DocumentNotFound
      @event = nil
      
    end
  end

  def edit
    @event = Event.find(params[:id])
    @organizers = User.without_the_owner current_user
    @groups = Group.by_name

    redirect_to events_path, :notice => t("flash.unauthorized_access") unless authorized_access?(@event)
  end

  def update
    @event = Event.find(params[:id])

    owner = User.find(@event.owner)

    @organizers = User.without_the_owner current_user
    @groups = Group.by_name

    if @event.update_attributes(params[:event])
      @event.update_list_organizers owner, params[:users]

      @event.update_list_groups params[:groups]

      redirect_to event_path(@event), :notice => t("flash.events.update.notice")
    else
      render :edit
    end
  end

  def presence
    event = Event.find params[:event_id]

    result = current_user.arrived_at event

    respond_to do |format|
      format.json { render json: { success: result } }
    end
  end
end
