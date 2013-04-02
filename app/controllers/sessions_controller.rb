class SessionsController < ApplicationController
  def get_type
    session = Session.find(params[:id])

    if session
      session_type = session.type

      respond_to do |format|
        format.json { render :json => {:error => false, :session_type => session_type} }
      end
    end
  end
end