class HomeController < ApplicationController
  layout 'home'

  def index
    @events = Event.last_events(3)
    @talkers = User.presentation_events
  end
end
