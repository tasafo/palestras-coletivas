class TalkService
  def initialize(talk)
    @talk = talk
  end

  def add_authors(owner, others)
    @talk.owner = owner.id.to_s if @talk.owner.nil?

    @talk.users = nil
    @talk.users << owner

    if others
      others.each do |author|
        user = User.find(author)
        @talk.users << [user] if user
      end
    end

    update_user_counters
  end

private

  def update_user_counters
    @talk.users.each do |author|
      user = User.find(author)
      user.counter_public_talks = user.talks.where(to_public: true).count
      user.save
    end
  end
end