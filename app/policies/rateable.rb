module Rateable
  def rate_by(user, rank)
    rating = ratings.find_or_create_by user: user

    rating.update rank: rank

    rating
  end

  def rating_by(user)
    ratings.find_or_initialize_by user: user
  end

  def rating
    return 0 if ratings.empty?

    rating = average(ratings.map(&:rank))

    round_by_point(rating)
  end

  private

  def average(ratings)
    ratings.inject { |lin, col| lin + col } / ratings.size
  end

  def round_by_point(rating)
    (2 * rating).round / 2.0
  end
end
