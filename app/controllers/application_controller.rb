#:nodoc:
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?

  rescue_from Mongoid::Errors::DeleteRestriction, with: :delete_restriction

  private

  def delete_restriction
    redirect_to "/#{controller_name}",
                notice: t("notice.delete.restriction.#{controller_name}")
  end

  def require_logged_user
    return if logged_in?

    redirect_to "#{login_path}?redirect=#{request.env['REQUEST_URI']}",
                alert: t('flash.must_be_logged')
  end

  def current_user
    @current_user ||= session[:user_id] && User.find(session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end

  def authorized_access?(model)
    return false if !logged_in? || model.nil?

    authorized = false
    model.users.each do |user|
      authorized = true if current_user == user
    end

    authorized
  end

  def owner?(model)
    return false if !logged_in? || model.nil?

    owner = false
    model.users.each do |user|
      owner = true if current_user == user && model.owner == user
    end

    owner
  end
end
