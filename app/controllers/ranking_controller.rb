class RankingController < ApplicationController
  def index
    limit = 10
    @organizers = UserQuery.new.ranking(:organizing_events, limit)
    @talkers = UserQuery.new.ranking(:presentation_events, limit)
    @participations = UserQuery.new.ranking(:participation_events, limit)
    @talks = TalkQuery.new.ranking_presentation_events(limit)
    @events = EventQuery.new.ranking_present_users(limit)
    @users_public_talks = UserQuery.new.ranking(:public_talks, limit)
    @watched_talks = UserQuery.new.ranking(:watched_talks, limit)
  end
end
