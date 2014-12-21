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
    @current_user ||= User.find(session[:user_id])
  end

  def logged_in?
    session[:user_id] && current_user
  end

  def authorized_access?(model)
    authorized = false

    if logged_in? 
      model.users.each do |user|
        if current_user.id == user.id
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
        if current_user.id == user.id && model.owner.to_s == user.id.to_s
          owner = true
        end
      end
    end

    owner
  end

end
