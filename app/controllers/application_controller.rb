class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :logged_in?

  def set_return_point(path, overwrite = false)
    if overwrite or cookies[:return_point].blank?
      cookies[:return_point] = path
    end
  end

  def return_point
    cookies[:return_point] ? cookies[:return_point] : root_path
  end

private
  def require_logged_user
    unless logged_in?
      set_return_point(request.env['PATH_INFO'])
      redirect_to login_path, :alert => t("flash.must_be_logged")
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
