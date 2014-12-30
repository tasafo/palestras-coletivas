class UsersController < ApplicationController
  before_action :require_logged_user, only: [:edit, :update]
  before_action :set_user, only: [:show, :edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to login_path, :notice => t("flash.signup.create.notice")
    else
      render :new
    end
  end

  def show
    unless @user.nil?
      @presenter = UserPresenter.new(@user, params[:page])
    else
      redirect_to root_path, :notice => t("flash.user_not_found")
    end
  end

  def edit
    if @user != current_user
      redirect_to talks_path, :notice => t("flash.unauthorized_access")
    end
  end

  def update
    if @user.update_attributes(user_params)
      redirect_to user_path(@user), :notice => t("flash.users.update.notice")
    else
      render :edit
    end 
  end

private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :username, :email, :password, :password_confirmation)
  end
end