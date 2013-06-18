class RatingsController < ApplicationController
  before_filter :find_rateable

  def create
    @rateable = find_rateable

    respond_to do |format|
      if @rateable.rate_by current_user, params[:rate][:my_rating]
        format.json { render json: { success: true } }
      else
        format.json { render json: { success: false } }
      end
    end
  end

  private

  def find_rateable
    rateable_class = params[:rateable_type].camelize.constantize
    rateable_class.find(params[:rateable_id])
  end
end