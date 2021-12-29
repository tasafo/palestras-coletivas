class TalkQuery
  def initialize(relation = Talk.scoped)
    @relation = relation
  end

  def presentation_events
    @relation.where(:counter_presentation_events.gt => 0)
             .order(counter_presentation_events: :desc, slugs: :asc).limit(5)
  end

  def search(search)
    @relation.with_users.where(to_public: true).full_text_search(search)
             .order(title: :asc)
  end

  def publics
    @relation.with_users.publics.order(created_at: :desc)
  end

  def owner(user)
    @relation.with_users.where(owner: user).order(created_at: :desc)
  end
end
