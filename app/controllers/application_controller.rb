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

  def save_object(option, object, users, args = {})
    operation = option == :new ? 'create' : 'update'
    object_name = object.class.to_s.downcase

    decorator = eval("#{object_name.titleize}Decorator.new")
    decorator.send :set_attributes, object, users, owner: args[:owner], params: args[:params]
    result = decorator.send operation.to_sym
    
    if result
      redirect_to "/#{object_name.pluralize}/#{object._slugs[0]}", notice: t("flash.#{object_name.pluralize}.#{operation}.notice")
    else
      render option
    end
  end
end
