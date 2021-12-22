class ExportSubscribersController < ApplicationController
  before_action :require_logged_user, only: %i[new create]
  before_action :set_event, only: %i[new create]

  def new
    @profiles = ExportSubscriber.profiles

    return if authorized_access?(@event)

    redirect_to event_path(@event), notice: t('flash.unauthorized_access')
  end

  def create
    profile = params[:profile]

    profile_lower = I18n.t("titles.export_subscribers.profiles.#{profile}")
                        .parameterize

    send_data ExportSubscriber.as_csv(@event, profile),
              filename: "certifico_#{@event.slug}_#{profile_lower}.csv",
              type: 'text/csv'
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end
end
