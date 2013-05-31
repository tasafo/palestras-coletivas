class UsersController < ApplicationController
  before_filter :require_logged_user, :only => [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      redirect_to login_path, :notice => t("flash.signup.create.notice")
    else
      render :new
    end
  end

  def show
    begin
      @user = User.find(params[:id])
      @talks = @user.talks.where(:to_public => true).page(params[:page]).per(5).order_by(:created_at => :desc)
      @participations = Enrollment.where(:present => true, :user => @user).order_by(:updated_at => :asc)

      user_profile = Gravatar.profile(@user.email)
      @gravatar = Gravatar.new user_profile
      @gravatar.show_profile
    rescue Mongoid::Errors::DocumentNotFound
      redirect_to root_path, :notice => t("flash.user_not_found")
    end
  end

  def edit
    @user = User.find(params[:id])

    if @user.id != current_user.id
      redirect_to talks_path, :notice => t("flash.unauthorized_access")
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      redirect_to user_path(@user), :notice => t("flash.users.update.notice")
    else
      render :edit
    end 
  end
end