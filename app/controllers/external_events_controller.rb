class ExternalEventsController < ApplicationController
  before_filter :require_logged_user, :only => [:new, :create, :edit, :update]

  def new
    @external_event = ExternalEvent.new
    @talk = Talk.find(params[:talk_id])
  end

  def create
    @external_event = ExternalEvent.new(params[:external_event])
    @talk = Talk.find(params[:talk_id])
    @talk.external_events << [@external_event]

    if @talk.save
      redirect_to talk_path(@talk), :notice => t("flash.external_event.create.notice")
    else
      render :new
    end
  end

  def edit
    @talk = Talk.find(params[:talk_id])
    @external_event = @talk.external_events.find(params[:id])
  end

  def update
    @talk = Talk.find(params[:talk_id])
    @external_event = @talk.external_events.find(params[:id])

    if @external_event.update_attributes(params[:external_event])
      redirect_to talk_path(@talk), :notice => t("flash.external_event.update.notice")
    else
      render :edit
    end
  end
end