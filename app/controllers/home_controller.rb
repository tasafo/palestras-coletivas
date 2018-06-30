#:nodoc:
class HomeController < ApplicationController
  # layout 'home'

  def index
    redirect_to events_path
  end
end
