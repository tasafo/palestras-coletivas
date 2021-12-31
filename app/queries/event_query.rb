class EventQuery
  def initialize(relation = Event.scoped)
    @relation = relation
  end

  def all_public
    @relation.publics.order(start_date: :desc)
  end

  def present_users
    @relation.where(:counter_present_users.gt => 0)
             .order(counter_present_users: :desc, slugs: :asc, edition: :asc).limit(5)
  end

  def accepts_submissions
    @relation.where(to_public: true, accepts_submissions: true,
                    :end_date.gte => Date.today).order(start_date: :desc)
  end

  def owner(user)
    @relation.with_relations.where(owner: user).order(created_at: :desc)
  end
end
