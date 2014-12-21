class UsersController < ApplicationController
  before_filter :require_logged_user, :only => [:edit, :update]
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
      @talks = @user.talks.where(:to_public => true).page(params[:page]).per(5).order_by(:created_at => :desc)
      @participations = Enrollment.where(:present => true, :user => @user).order_by(:updated_at => :asc)

      user_profile = Gravatar.profile(@user.email)
      @gravatar = Gravatar.new user_profile
      @gravatar.show_profile
    else
      redirect_to root_path, :notice => t("flash.user_not_found")
    end
  end

  def edit
    if @user.id != current_user.id
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