class ApplicationController < ActionController::Base
  include Pagy::Backend

  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?

  def pagy_get_items(array, pagy)
    array[pagy.offset, pagy.items]
  end

  private

  def require_logged_user
    return if logged_in?

    redirect_to "#{login_path}?redirect=#{request.env['REQUEST_URI']}",
                alert: t('flash.must_be_logged')
  end

  def current_user
    user_id = session[:user_id]

    @current_user ||= user_id && User.find(user_id)
  end

  def logged_in?
    !current_user.nil?
  end

  def authorized_access?(model)
    return false if !logged_in? || model.nil?

    found = model.users.select { |user| current_user == user }

    found.any?
  end

  def user_owner?(model)
    return false if !logged_in? || model.nil?

    found = model.users.select { |user| current_user == user && model.owner == user }

    found.any?
  end

  def prepare_attributes(owner, action, object_params)
    arguments = { owner: owner, logged: current_user, user_ids: params[:users],
                  action: action, fields: object_params }

    UsersDecorator.new(**arguments).prepare
  end
end
