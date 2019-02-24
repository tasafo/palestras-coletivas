#:nodoc:
class PasswordResetsController < ApplicationController
  before_action :set_user, only: %i[edit update]

  def new; end

  def create
    user = User.find_by(email: params[:email])

    if user
      user.send_password_reset

      message = t('flash.reset_password.create.notice')
      redirect_to new_password_reset_path, notice: message
    else
      message = t('flash.reset_password.create.alert')
      redirect_to new_password_reset_path, alert: message
    end
  end

  def edit; end

  def update
    if @user.password_reset_sent_at < 2.hours.ago
      message = t('flash.reset_password.update.alert')

      redirect_to new_password_reset_path, alert: message
    elsif @user.update(user_params)
      message = t('flash.reset_password.update.notice')

      redirect_to new_password_reset_path, notice: message
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find_by(password_reset_token: params[:id])
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
