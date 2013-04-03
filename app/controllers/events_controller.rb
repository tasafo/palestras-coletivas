class EventsController < ApplicationController
  before_filter :require_logged_user, :only => [:new, :create, :edit, :update]

  def index
    if logged_in?
      @events = current_user.events.order_by(:start_date => :desc)
    else
      @events = Event.all_public
    end
  end

  def new
    @event = Event.new
    
    guest_list
  end

  def create
    @event = Event.new(params[:event])

    @event.owner = current_user.id

    guest_list

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
      @event.update_list_organizers current_user, params[:users]

      @event.update_list_groups params[:groups]

      redirect_to event_path(@event), :notice => t("flash.events.update.notice")
    else
      render :edit
    end
  end

private
  def guest_list
    @organizers = User.organizers current_user

    @groups = Group.order_by(:name => :asc)
  end
end