class RankingController < ApplicationController
  def index
    @organizers = UserQuery.new.ranking(:organizing_events)
    @talkers = UserQuery.new.ranking(:presentation_events)
    @participations = UserQuery.new.ranking(:participation_events)
    @talks = TalkQuery.new.presentation_events
    @events = EventQuery.new.present_users
    @users_public_talks = UserQuery.new.ranking(:public_talks)
    @watched_talks = UserQuery.new.ranking(:watched_talks)
  end
end
