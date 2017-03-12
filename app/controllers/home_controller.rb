#:nodoc:
class HomeController < ApplicationController
  layout 'home'

  def index
    @events = Event.where(to_public: true).desc(:start_date).limit(3)
    @talkers = UserQuery.new.ranking(:presentation_events)
  end
end
