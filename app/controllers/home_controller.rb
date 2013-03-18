class HomeController < ApplicationController
  def index
    @talks = Talk.where(:to_public => true).page(params[:page]).per(5).order_by(:created_at => :desc)
  end
end