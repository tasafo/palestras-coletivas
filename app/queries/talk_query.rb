class TalkQuery
  def initialize(relation = Talk.scoped)
    @relation = relation
  end

  def presentation_events
    @relation.where(:counter_presentation_events.gt => 0).desc(:counter_presentation_events).asc(:_slugs).limit(5)
  end

  def search(search)
    @relation.where(to_public: true).full_text_search(search).asc(:title)
  end

  def publics
    @relation.where(to_public: true).desc(:created_at)
  end

  def all_user(user)
    @relation.where(owner: user.id.to_s).desc(:created_at)
  end
end