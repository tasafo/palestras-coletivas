class LoginController < ApplicationController
  def new
    @redirect = params[:redirect]
  end

  def create
    @user = Authenticator.authenticate(params[:email], params[:password])

    if @user
      session_user(@user.id)
      redirect_to redirect_path(params[:redirect])
    else
      flash[:alert] = t('flash.login.create.alert')
      render :new
    end
  end

  def destroy
    reset_session

    redirect_to root_path
  end

  private

  def redirect_path(param)
    param.blank? ? root_path : param
  end

  def session_user(user_id)
    reset_session
    session[:user_id] = user_id
  end
end
