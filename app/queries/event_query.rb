class EventQuery
  def initialize(relation = Event.scoped)
    @relation = relation
  end

  def all_public
    @relation.where(to_public: true).desc(:start_date)
  end

  def all_user(user)
    @relation.where(owner: user.id.to_s).desc(:created_at)
  end

  def present_users
    @relation.where(:counter_present_users.gt => 0).desc(:counter_present_users).asc(:_slugs).asc(:edition).limit(5)
  end

  def accepts_submissions
    @relation.where(to_public: true, accepts_submissions: true, :end_date.gte => Date.today).desc(:start_date)
  end
end