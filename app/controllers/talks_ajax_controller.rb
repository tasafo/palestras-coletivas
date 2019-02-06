class TalksAjaxController < PersistenceController
  layout false

  def index
    @search = params[:search]
    @my = !params[:my].nil?

    @talks = search_talks @search, @my, params[:page]

    render nothing: true, status: 404 if params[:page] && @talks.blank?
  end

  private

  def search_talks(search, my, page)
    talks = if logged_in? && my
              TalkQuery.new.owner(current_user)
            else
              if search.blank?
                TalkQuery.new.publics
              else
                Kaminari.paginate_array(TalkQuery.new.search(search))
              end
            end

    talks.page(page).per(8)
  end
end
