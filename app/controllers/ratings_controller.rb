class RatingsController < ApplicationController
  before_action :find_rateable

  def create
    @rateable = find_rateable

    result = @rateable.rate_by current_user, params[:rate][:my_rating]

    respond_to do |format|
      format.json { render json: { success: result.valid? } }
    end
  end

  private

  def find_rateable
    rateable_class = [Event].find do |rate|
      rate.name == params[:rateable_type].classify
    end

    rateable_class.find(params[:rateable_id])
  end
end
