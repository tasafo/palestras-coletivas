class EventPresenter
  attr_reader :event, :dates, :authorized, :open_enrollment, :can_record_presence, :show_users_present,
    :users_present, :users_active, :crowded, :new_subscription, :the_user_is_speaker, :enrollment,
    :image_top, :can_vote

  def initialize(event, authorized, user_logged_in = nil)
    prepare_event event, authorized, user_logged_in
  end

  def show_checkin
    (@crowded && @enrollment && @enrollment.active?) || !@crowded
  end

  def address
    EventPolicy.new(@event).address
  end

  def in_progress?
    EventPolicy.new(@event).in_progress?
  end

  private
    def prepare_event(event, authorized, user_logged_in = nil)
      if event
        @dates = (event.start_date..event.end_date).to_a

        @open_enrollment = event.deadline_date_enrollment >= Date.today

        @users_present = prepare_users_present event

        @users_active = prepare_users_active event

        @crowded = @users_active.count >= event.stocking

        logged event, user_logged_in

        @image_top = ('01'..'12').to_a.sample

        @can_vote = prepare_can_vote(event)

        prepare_authorized(event, authorized)
      end
    end

    def prepare_authorized(event, authorized)
      @authorized = authorized

      @can_record_presence = @authorized && Date.today >= event.start_date

      @show_users_present = Date.today > event.end_date && !@can_record_presence

      @event = event
      unless event.to_public
        @event = nil unless @authorized
      end
    end

    def prepare_can_vote(event)
      event && event.accepts_submissions && event.end_date >= Date.today
    end

    def prepare_users_present(event)
      users_present = []
      event.enrollments.presents.each { |enrollment| users_present << enrollment.user }
      users_present.sort_by! { |user| user._slugs[0] }
    end

    def prepare_users_active(event)
      users_active = []
      event.enrollments.actives.each do |enrollment|
        users_active << { :name => enrollment.user._slugs[0], :enrollment => enrollment }
      end
      users_active.sort_by! { |user| user[:name] }
    end

    def logged(event, user_logged_in = nil)
      @new_subscription = true

      if user_logged_in
        @enrollment = Enrollment.where(:event => event, :user => user_logged_in).first

        @new_subscription = false if @enrollment

        @the_user_is_speaker = false

        event.schedules.each do |schedule|
          if schedule.talk?
            schedule.talk.users.each do |user|
              @the_user_is_speaker = true if user.id == user_logged_in.id
            end
          end
        end

        @open_enrollment = false if @the_user_is_speaker || @authorized
      end
    end
end