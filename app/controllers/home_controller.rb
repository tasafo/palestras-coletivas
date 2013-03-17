class HomeController < ApplicationController
  def index
    @talks = Talk.where(:to_public => true).order_by(:created_at => "DESC").limit(10).entries
  end
end