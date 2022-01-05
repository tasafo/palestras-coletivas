class HomeController < ApplicationController
  layout 'home'

  def index
    @events = Event.upcoming
  end
end
