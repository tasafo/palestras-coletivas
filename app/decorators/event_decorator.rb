class EventDecorator
  def initialize(event)
    @event = event
  end

  def create(users, owner)
    @users = users
    @event.owner = owner.id.to_s
    @event.save && update_list_organizers
  end

  def update(users, params)
    @users = users
    @event.update_attributes(params) && update_list_organizers
  end

private

  def update_list_organizers
    @owner = User.find(@event.owner) unless @event.owner.nil?
    
    save_coordinates

    save_owner
    
    save_organizers

    true
  end

  def save_coordinates
    results = Geocoder.search(EventPolicy.new(@event).address)
    
    if results
      @event.coordinates = [ results[0].geometry['location']['lng'], results[0].geometry['location']['lat'] ]
      @event.save
    end
  end

  def save_owner
    if @event.users?
      @owner.set_counter(:organizing_events, :dec)

      @event.users.each do |organizer|
        organizer.set_counter(:organizing_events, :dec)
      end

      @event.users = nil
    end

    @event.users << @owner
    @owner.set_counter(:organizing_events, :inc)
  end

  def save_organizers
    if @users
      @users.each do |organizer|
        user = User.find(organizer)
        if user
          @event.users << user
          user.set_counter(:organizing_events, :inc)
        end
      end
    end
  end
end