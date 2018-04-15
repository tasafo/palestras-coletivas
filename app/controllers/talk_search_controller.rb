#:nodoc:
class TalkSearchController < ApplicationController
  def create
    @talks = TalkQuery.new.search(params[:search]) unless params[:search].blank?

    respond_to do |format|
      format.json { render json: @talks }
    end
  end
end
