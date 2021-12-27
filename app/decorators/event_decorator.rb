class EventDecorator
  def initialize(event, users, args = {})
    @event = event
    @users = users
    @owner = args[:owner]
    @params = args[:params]
  end

  def create
    @event.owner = @owner
    update_list_organizers
    @event.save
  end

  def update
    update_list_organizers
    @event.update(@params)
  end

  private

  def update_list_organizers
    @owner = @event&.owner

    @event.users = nil if @event.users?
    @event.users << @owner

    @users&.each do |organizer|
      user = User.find(organizer)
      @event.users << user if user
    end
  end
end
