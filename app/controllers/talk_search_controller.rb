class TalkSearchController < ApplicationController
  def create
    search = params[:search]
    @talks = TalkQuery.new.search(search) unless search.blank?

    respond_to do |format|
      format.json { render jsonapi: @talks, meta: { total: @talks.size } }
    end
  end
end
