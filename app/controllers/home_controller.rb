class HomeController < ApplicationController
  def index
    @talks = Talk.all.entries
  end
end