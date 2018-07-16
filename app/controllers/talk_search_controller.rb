#:nodoc:
class TalkSearchController < ApplicationController
  def index
    @talks = TalkQuery.new.search(params[:search]).limit(10) unless params[:search].blank?

    respond_to do |format|
      format.json { render json: @talks }
    end
  end
end
