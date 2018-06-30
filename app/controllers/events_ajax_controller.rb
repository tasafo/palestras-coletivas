class EventsAjaxController < PersistenceController
  layout false

  def index
    @my = !params[:my].blank?

    @events = if logged_in? && @my
                EventQuery.new.owner(current_user)
              else
                EventQuery.new.all_public
              end
    @events = @events.page(params[:page]).per(3)

    render nothing: true, status: 404 if params[:page] && @events.blank?
  end
end
