class PasswordResetsController < ApplicationController
  before_action :set_user, only: [:edit, :update]

  def new
  end

  def create
    user = User.find_by(:email => params[:email])

    if user
      user.send_password_reset
      redirect_to new_password_reset_path, :notice => t("flash.reset_password.create.notice")
    else
      redirect_to new_password_reset_path, :notice => t("flash.reset_password.create.alert")
    end
  end

  def edit
  end

  def update
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :alert => t("flash.reset_password.update.alert")
    elsif @user.update_attributes(user_params)
      redirect_to new_password_reset_path, :notice => t("flash.reset_password.update.notice")
    else
      render :edit
    end
  end

private

  def set_user
    @user = User.find_by(:password_reset_token => params[:id])
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end