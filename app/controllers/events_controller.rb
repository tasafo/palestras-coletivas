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
    @organizers = organizers
    @groups = groups
  end

  def create
    @event = Event.new(params[:event])
    @event.owner = current_user.id
    @event.users << current_user

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
      @unauthorized = unauthorized

    rescue Mongoid::Errors::DocumentNotFound
      redirect_to root_path
    end
  end

  def edit
    @event = Event.find(params[:id])
    @organizers = organizers
    @groups = groups

    redirect_to events_path, :notice => t("flash.unauthorized_access") if unauthorized
  end

  def update
    @event = Event.find(params[:id])

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
  def organizers
    User.not_in(:_id => current_user.id.to_s).order_by(:name => :asc)
  end

  def groups
    Group.order_by(:name => :asc)
  end

  def unauthorized
    unauthorized = true

    if logged_in? 
      @event.users.each do |o|
        if current_user.id == o.id
          unauthorized = false
        end
      end
    end

    unauthorized
  end

  def all_public_events
    Event.where(:to_public => true).order_by(:start_date => :desc)
  end
end