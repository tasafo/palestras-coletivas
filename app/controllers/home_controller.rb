class HomeController < ApplicationController
  def index
    @talk = Talk.new
    @search = ""

    if params[:talk].nil?
      @talks = all_public_talks
    else
      @search = params[:talk][:search]

      if @search.empty?
        @talks = all_public_talks
      else
        @talks = Kaminari.paginate_array(Talk.fulltext_search(@search, :index => 'fulltext_index_title_tags', :published => [ true ])).page(params[:page]).per(5)
      end
    end
  end

  private
    def all_public_talks
      Talk.where(:to_public => true).page(params[:page]).per(5).order_by(:created_at => :desc)
    end
end