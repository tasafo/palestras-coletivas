class TalkDecorator < UsersDecorator
  def initialize(talk, users, args = {})
    super(talk, users, args)
  end
end
