class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :logged_in?

private
  def require_logged_user
    unless logged_in?
      redirect_to "#{login_path}?redirect=#{request.env['REQUEST_URI']}", :alert => t("flash.must_be_logged")
    end
  end

  def current_user
    user = User.find(session[:user_id]) if session[:user_id]

    @current_user ||= user ? user : nil
  end

  def logged_in?
    session[:user_id] && current_user
  end

  def authorized_access?(model)
    authorized = false

    if logged_in? 
      model.users.each do |user|
        if current_user == user
          authorized = true
        end
      end
    end

    authorized
  end

  def owner?(model)
    owner = false

    if logged_in?
      model.users.each do |user|
        if current_user == user && model.owner == user
          owner = true
        end
      end
    end

    owner
  end
end
