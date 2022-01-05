class EventQuery
  def initialize(relation = Event.scoped)
    @relation = relation
  end

  def search(search)
    @relation.where(to_public: true)
             .where('$text' => { '$search' => search }).order(name: :asc)
  end

  def publics
    @relation.publics.order(start_date: :desc)
  end

  def ranking_present_users(limit)
    @relation.where(:counter_present_users.gt => 0)
             .order(counter_present_users: :desc, slugs: :asc, edition: :asc).limit(limit)
  end

  def accepts_submissions
    @relation.where(to_public: true, accepts_submissions: true,
                    :end_date.gte => Date.today).order(start_date: :desc)
  end

  def owner(user)
    @relation.with_relations.where(owner: user).order(created_at: :desc)
  end

  def select(user, search, my_events)
    if user && !my_events.blank?
      owner(user)
    elsif search.blank?
      publics
    else
      search(search)
    end
  end
end
