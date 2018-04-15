#:nodoc:
class ActivitiesController < ApplicationController
  def create
    activity = Activity.find(params[:id])

    if activity
      respond_to do |format|
        format.json {
          render json: { error: false, type_activity: activity.type }
        }
      end
    end
  end
end
