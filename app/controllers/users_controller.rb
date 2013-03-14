class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      redirect_to login_path,
        :notice => t("flash.signup.create.notice")
    else
      render :new
    end
  end

  def show
    
  end
end