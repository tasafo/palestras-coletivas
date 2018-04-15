#:nodoc:
class WatchesController < ApplicationController
  def create
    talk = Talk.find(params[:talk_id])

    user = current_user

    action = user.watched_talk?(talk) ? 'unwatch_talk!' : 'watch_talk!'

    user.send action, talk

    redirect_to talk_path(talk)
  end
end
