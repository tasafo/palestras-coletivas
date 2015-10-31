class ExternalEventsController < ApplicationController
  before_action :require_logged_user, only: [:new, :create, :edit, :update]
  before_action :set_talk, only: [:new, :create, :edit, :update]

  def new
    @external_event = ExternalEvent.new
  end

  def create
    @external_event = ExternalEvent.new(external_event_params)
    @talk.external_events << [@external_event]

    if @talk.save
      redirect_to talk_path(@talk), :notice => t("flash.external_event.create.notice")
    else
      render :new
    end
  end

  def edit
    @external_event = @talk.external_events.find(params[:id])
  end

  def update
    @external_event = @talk.external_events.find(params[:id])

    if @external_event.update_attributes(external_event_params)
      redirect_to talk_path(@talk), :notice => t("flash.external_event.update.notice")
    else
      render :edit
    end
  end

private

  def set_talk
    @talk = Talk.find(params[:talk_id])
  end

  def external_event_params
    params.require(:external_event).permit(:name, :date, :place, :url, :active)
  end
end