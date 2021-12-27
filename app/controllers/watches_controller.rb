class WatchesController < ApplicationController
  def create
    talk = Talk.find(params[:talk_id])

    action = current_user.watched_talk?(talk) ? 'unwatch_talk' : 'watch_talk'

    current_user.send(action, talk)

    redirect_to talk_path(talk)
  end
end
