class PasswordResetsController < ApplicationController
  def new
  end

  def create
    begin
      user = User.find_by(:email => params[:email])
      user.send_password_reset if user
      redirect_to root_url, :notice => t("flash.reset_password.create.notice")
    rescue Mongoid::Errors::DocumentNotFound
      redirect_to new_password_reset_path, :notice => t("flash.reset_password.create.alert")
    end
  end

  def edit
    @user = User.find_by(:password_reset_token => params[:id])
  end

  def update
    @user = User.find_by(:password_reset_token => params[:id])

    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :alert => t("flash.reset_password.update.alert")
    elsif @user.update_attributes(params[:user])
      redirect_to root_url, :notice => t("flash.reset_password.update.notice")
    else
      render :edit
    end
  end
end