#:nodoc:
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?

  rescue_from Mongoid::Errors::InvalidFind, with: :record_not_found

  private

  def record_not_found
    redirect_to root_path
  end

  def require_logged_user
    redirect_to "#{login_path}?redirect=#{request.env['REQUEST_URI']}",
                alert: t('flash.must_be_logged') unless logged_in?
  end

  def current_user
    user = User.find(session[:user_id]) if session[:user_id]

    @current_user ||= user ? user : nil
  end

  def logged_in?
    !current_user.nil?
  end

  def authorized_access?(model)
    return false unless logged_in?

    authorized = false
    model.users.each do |user|
      authorized = true if current_user == user
    end

    authorized
  end

  def owner?(model)
    return false unless logged_in?

    owner = false
    model.users.each do |user|
      owner = true if current_user == user && model.owner == user
    end

    owner
  end
end
