class EventQuery
  def initialize(relation = Event.scoped)
    @relation = relation
  end

  def all_public
    @relation.where(to_public: true).desc(:start_date)
  end

  def present_users
    @relation.where(:counter_present_users.gt => 0).desc(:counter_present_users).asc(:_slugs).asc(:edition).limit(5)
  end
end