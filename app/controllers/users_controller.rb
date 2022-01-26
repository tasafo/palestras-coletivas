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
    user_talks = @user.talks.publics
    talks = user_talks.order(created_at: :desc).to_a

    @events = @user.events.publics.order(start_date: :desc).to_a
    @schedules_talks = user_talks.where(:counter_presentation_events.gt => 0).to_a
    @participations = @user.enrollments.where(present: true).order(updated_at: :asc).to_a
    @gravatar = Gravatar.new(@user.email)

    @pagy, @records = pagy(talks, count: talks.count)
  end

  def edit
    redirect_to root_path and return if @user != current_user
  end

  def update
    @user.destroy_avatar if user_params[:remove_avatar] == '1'

    if @user.update(user_params)
      redirect_to user_path(@user), notice: t('flash.users.update.notice')
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:id])

    redirect_to root_path unless @user
  end

  def user_params
    params.require(:user).permit(
      :name, :username, :email, :password, :password_confirmation,
      :avatar, :remove_avatar
    )
  end
end
