class TalkSearchController < ApplicationController
  def create
    search = params[:search]
    @talks = TalkQuery.new.search(search) unless search.blank?

    respond_to do |format|
      format.json { render json: @talks }
    end
  end
end
