class LoginController < ApplicationController
  def new
     @redirect = params[:redirect]
  end

  def create
    @user = Authenticator.authenticate(params[:email], params[:password])
    redirect = params[:redirect]

    if @user
      reset_session
      session[:user_id] = @user.id

      redirect_to (redirect.blank? ? root_path : redirect)
    else
      flash.now[:alert] = t("flash.login.create.alert")
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end
end