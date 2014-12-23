class EventPresenter
  attr_reader :dates, :authorized, :open_enrollment, :can_record_presence, :show_users_present,
    :users_present, :users_active, :crowded, :new_subscription, :the_user_is_speaker, :enrollment,
    :image_top, :can_vote

  def initialize(event, user_logged_in, authorized)
    prepare_event event, user_logged_in, authorized
  end

  private
    def prepare_event(event, user_logged_in, authorized)
      if event
        @authorized = authorized
        @dates = (event.start_date..event.end_date).to_a
        @open_enrollment = event.deadline_date_enrollment >= Date.today
        @can_record_presence = @authorized && Date.today >= event.start_date
        @show_users_present = Date.today > event.end_date && !@can_record_presence

        @users_present = prepare_users_present event

        @users_active = prepare_users_active event

        @crowded = @users_active.count >= event.stocking

        @new_subscription = true

        logged event, user_logged_in

        unless event.to_public
          event = nil unless @authorized
        end

        @image_top = ('01'..'12').to_a.sample

        @can_vote = event && event.accepts_submissions && event.end_date >= Date.today
      end  
    end

    def prepare_users_present(event)
      users_present = []
      event.enrollments.presents.each { |enrollment| users_present << enrollment.user }
      users_present.sort_by! { |user| user._slugs }
    end

    def prepare_users_active(event)
      users_active = []
      event.enrollments.actives.each do |enrollment|
        users_active << { :name => enrollment.user._slugs, :enrollment => enrollment }
      end
      users_active.sort_by! { |user| user[:name] }
    end

    def logged(event, user_logged_in)
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