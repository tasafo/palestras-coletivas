class TalkDecorator
  def initialize(talk, users, args = {})
    @talk = talk
    @users = users
    @owner = args[:owner]
    @params = args[:params]
  end

  def create
    @talk.owner = @owner
    add_authors
    @talk.save
  end

  def update
    add_authors
    @talk.update(@params)
  end

  private

  def clean_presentation_data
    return unless @talk.presentation_url.blank?

    @talk.code = ''
    @talk.thumbnail = ''
  end

  def add_authors
    clean_presentation_data

    @owner = @talk&.owner

    @talk.users = nil
    @talk.users << @owner

    @users&.each do |author|
      user = User.find(author)
      @talk.users << [user] if user
    end
  end
end
