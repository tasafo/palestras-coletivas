#:nodoc:
class ExportSubscribersController < ApplicationController
  before_action :require_logged_user, only: [:new, :create]
  before_action :set_event, only: [:new, :create]

  def new
    @profiles = ExportSubscriber.profiles

    message = t('flash.unauthorized_access')

    redirect_to event_path(@event), notice: message unless authorized_access?(@event)
  end

  def create
    profile = params[:profile]

    profile_lower = I18n.t("titles.export_subscribers.profiles.#{profile}").parameterize

    send_data ExportSubscriber.as_csv(@event, profile),
      filename: "certifico_#{@event._slugs[0]}_#{profile_lower}.csv",
      type: "text/csv"
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end
end