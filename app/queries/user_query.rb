class UserQuery
  def initialize(relation = User.scoped)
    @relation = relation
  end

  def without_the_owner(user)
    @relation.not_in(_id: user).order(slugs: :asc)
  end

  def ranking(type)
    counter = "counter_#{type}".to_sym

    @relation.where(counter.gt => 0).desc(counter).asc(:slugs).limit(5)
  end
end
