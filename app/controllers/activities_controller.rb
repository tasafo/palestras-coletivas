class ActivitiesController < ApplicationController
  def get_type
    activity = Activity.find(params[:id])

    if activity
      type_activity = activity.type

      respond_to do |format|
        format.json {
          render json: {error: false, type_activity: type_activity}
        }
      end
    end
  end
end
