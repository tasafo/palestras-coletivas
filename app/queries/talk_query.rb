class TalkQuery
  def initialize(relation = Talk.scoped)
    @relation = relation
  end

  def presentation_events
    @relation.where(:counter_presentation_events.gt => 0)
             .desc(:counter_presentation_events).asc(:_slugs).limit(5)
  end

  def search(search)
    @relation.with_users.where(to_public: true).full_text_search(search)
             .asc(:title)
  end

  def publics
    @relation.with_users.publics.desc(:created_at)
  end

  def owner(user)
    @relation.with_users.where(owner: user).desc(:created_at)
  end
end
