class EventsController < ApplicationController
  before_filter :require_logged_user, :only => [:new, :create, :edit, :update]

  def index
    if logged_in?
      @events = current_user.events.order_by(:start_date => :desc)
    else
      @events = all_public_events
    end
  end

  def new
    @event = Event.new
    
    guest_list
  end

  def create
    @event = Event.new(params[:event])
    @event.owner = current_user.id
    @event.users << current_user

    guest_list

    if @event.save
      if params[:users]
        params[:users].each do |m|
          user = User.find(m)
          @event.users << [user] if user
        end
      end

      if params[:groups]
        params[:groups].each do |g|
          group = Group.find(g)
          @event.groups << [group] if group
        end
      end

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

      unless @event.to_public
        @event = nil unless @authorized
      end
    rescue Mongoid::Errors::DocumentNotFound
      redirect_to root_path
    end
  end

  def edit
    @event = Event.find(params[:id])

    guest_list

    redirect_to events_path, :notice => t("flash.unauthorized_access") unless authorized_access?(@event)
  end

  def update
    @event = Event.find(params[:id])

    guest_list

    if @event.update_attributes(params[:event])
      @event.users = nil
      @event.groups = nil
      @event.users << current_user

      if params[:users]
        params[:users].each do |m|
          user = User.find(m)
          @event.users << [user] if user
        end
      end

      if params[:groups]
        params[:groups].each do |g|
          group = Group.find(g)
          @event.groups << [group] if group
        end
      end

      redirect_to event_path(@event), :notice => t("flash.events.update.notice")
    else
      render :edit
    end
  end

private
  def guest_list
    @organizers = User.not_in(:_id => current_user.id.to_s).order_by(:name => :asc)
    @groups = Group.order_by(:name => :asc)
  end

  def all_public_events
    Event.where(:to_public => true).order_by(:start_date => :desc)
  end
end