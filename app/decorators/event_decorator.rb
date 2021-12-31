class EventDecorator < UsersDecorator
  def initialize(event, users, args = {})
    super(event, users, args)
  end
end
