class HomeController < ApplicationController
  def index
    @talks = Talk.where(:to_public => true).order_by(:created_at => "DESC").entries
  end
end