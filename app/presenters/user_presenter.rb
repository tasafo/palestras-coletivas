class UserPresenter
  attr_reader :talks, :participations, :gravatar

  def initialize(user, page)
    @talks = user.talks.publics.desc(:created_at).page(page).per(12)
    @participations = Enrollment.where(present: true, user: @user).asc(:updated_at)
    @gravatar = Gravatar.new(user.email).fields
  end
end
