class RankingController < ApplicationController
  def index
    @organizers = User.organizing_events
    @talkers = User.presentation_events
    @participations = User.participation_events
    @talks = TalkQuery.new.presentation_events
    @events = EventQuery.new.present_users
    @users_public_talks = User.public_talks
    @top_talk_watchers = User.top_talk_watchers
  end
end
