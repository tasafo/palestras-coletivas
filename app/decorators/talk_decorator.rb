#:nodoc:
class TalkDecorator
  def initialize(talk, users, args = {})
    @talk = talk
    @users = users
    @owner = args[:owner]
    @params = args[:params]
  end

  def create
    @talk.owner = @owner
    @talk.save && add_authors
  end

  def update
    @talk.update(@params) && add_authors
  end

  private

  def clean_presentation_data
    return unless @talk.presentation_url.blank?

    @talk.code = ''
    @talk.thumbnail = ''
  end

  def add_authors
    clean_presentation_data

    @owner = @talk.owner if @talk.owner

    @talk.users = nil
    @talk.users << @owner

    @users&.each do |author|
      user = User.find(author)
      @talk.users << [user] if user
    end

    update_user_counters

    true
  end

  def update_user_counters
    @talk.users.each do |author|
      user = User.find(author)
      user.counter_public_talks = user.talks.publics.count
      user.save
    end
  end
end
