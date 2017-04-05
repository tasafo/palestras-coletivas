#:nodoc:
class HomeController < ApplicationController
  layout 'home'

  def index
    @events = Event.upcoming
    @talkers = UserQuery.new.ranking(:presentation_events)
  end
end
