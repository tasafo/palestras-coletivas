class TalkInfoController < ApplicationController
  def create
    oembed = Oembed.new(params[:link]).open_presentation

    hash = if oembed
             { error: false, title: oembed.title, code: oembed.code,
               thumbnail: oembed.thumbnail, description: oembed.description }
           else
             { error: true }
           end

    respond_to do |format|
      format.json { render json: hash }
    end
  end
end
