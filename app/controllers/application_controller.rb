class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :logged_in?

private
  def require_logged_user
    redirect_to login_path, :alert => t("flash.must_be_logged") unless logged_in?
  end

  def current_user
    @current_user ||= User.find(session[:user_id])
  end

  def logged_in?
    session[:user_id] && current_user
  end
end
