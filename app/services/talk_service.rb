class TalkService
  def initialize(talk, users, owner, params = nil)
    @talk = talk
    @users = users
    @owner = owner
    @params = params
  end

  def create
    @talk.owner = @owner.id.to_s if @talk.owner.nil?
    add_authors && @talk.save
  end

  def update
    @talk.update_attributes(@params) && add_authors
  end

private

  def add_authors
    @talk.users = nil
    @talk.users << @owner

    if @users
      @users.each do |author|
        user = User.find(author)
        @talk.users << [user] if user
      end
    end

    update_user_counters

    true
  end

  def update_user_counters
    @talk.users.each do |author|
      user = User.find(author)
      user.counter_public_talks = user.talks.where(to_public: true).count
      user.save
    end
  end
end