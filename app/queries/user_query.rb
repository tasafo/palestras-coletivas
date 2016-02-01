#:nodoc:
class UserQuery
  def initialize(relation = User.scoped)
    @relation = relation
  end

  def without_the_owner(user)
    @relation.not_in(_id: user).asc(:_slugs)
  end

  def ranking(type)
    eval("@relation.where(:counter_#{type}.gt => 0).desc(:counter_#{type})
         .asc(:_slugs).limit(5)")
  end
end
