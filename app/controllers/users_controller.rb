class UsersController < ApplicationController
  before_action :require_logged_user, only: %i[edit update]
  before_action :set_user, only: %i[show edit update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to login_path, notice: t('flash.signup.create.notice')
    else
      render :new
    end
  end

  def show
    query = @user.talks.publics.order(created_at: :desc)
    @pagy, @records = pagy(query, count: query.count)
    @participations = @user.enrollments.where(present: true).order(updated_at: :asc)
    @gravatar = Gravatar.new(@user.email)
  end

  def edit
    redirect_to root_path and return if @user != current_user
  end

  def update
    @user.destroy_avatar if user_params[:avatar] || user_params[:remove_avatar] == '1'

    if @user.update(user_params)
      redirect_to user_path(@user), notice: t('flash.users.update.notice')
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.with_relations.find(params[:id])

    redirect_to root_path unless @user
  end

  def user_params
    params.require(:user).permit(
      :name, :username, :email, :password, :password_confirmation,
      :avatar, :remove_avatar
    )
  end
end
