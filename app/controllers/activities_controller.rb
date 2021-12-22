class ActivitiesController < ApplicationController
  def create
    activity = Activity.find(params[:id])

    return unless activity

    respond_to do |format|
      format.json do
        render json: { error: false, type_activity: activity.type }
      end
    end
  end
end
