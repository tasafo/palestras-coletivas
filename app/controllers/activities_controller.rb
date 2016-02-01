#:nodoc:
class ActivitiesController < ApplicationController
  def create
    activity = Activity.find(params[:id])

    if activity && activity.id > 0
      type = activity.type

      respond_to do |format|
        format.json { render json: { error: false, type_activity: type } }
      end
    end
  end
end
