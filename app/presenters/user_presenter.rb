class UserPresenter
  attr_reader :talks, :participations, :gravatar

  def initialize(user, page)
    @talks = user.talks.where(to_public: true).desc(:created_at).page(page).per(5)
    @participations = Enrollment.where(present: true, user: @user).asc(:updated_at)

    @gravatar = Gravatar.new(user.email)
  end
end