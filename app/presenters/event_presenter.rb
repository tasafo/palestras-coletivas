#:nodoc:
class EventPresenter
  attr_reader :event, :dates, :authorized, :open_enrollment,
              :can_record_presence, :show_users_present, :users_present,
              :users_active, :crowded, :new_subscription, :the_user_is_speaker,
              :enrollment, :image_top, :can_vote, :view_certificates

  def initialize(event, authorized, user_logged_in = nil)
    prepare_event event, authorized, user_logged_in
  end

  def show_checkin
    !@event.block_presence && @enrollment && @enrollment.active? &&
      Date.today >= @event.start_date
  end

  def address
    EventPolicy.new(@event).address
  end

  def in_progress?
    EventPolicy.new(@event).in_progress?
  end

  private

  def prepare_event(event, authorized, user_logged_in = nil)
    return unless event

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

  def prepare_authorized(event, authorized)
    @event = event
    @authorized = authorized

    @can_record_presence = record_presence?
    @show_users_present = users_present?
    @view_certificates = certificates?

    return if event.to_public

    @event = nil unless @authorized
  end

  def record_presence?
    @authorized && Date.today >= @event.start_date
  end

  def users_present?
    Date.today > @event.end_date && !@can_record_presence
  end

  def certificates?
    @event.issue_certificates && @authorized && Date.today > event.end_date
  end

  def prepare_can_vote(event)
    event && event.accepts_submissions && event.end_date >= Date.today
  end

  def prepare_users_present(event)
    users_present = []

    event.enrollments.with_user.presents.each do |enrollment|
      users_present << enrollment.user
    end

    users_present.sort_by! { |user| user._slugs[0] }
  end

  def prepare_users_active(event)
    users_active = []

    event.enrollments.actives.each do |enrollment|
      name = enrollment.user._slugs[0]
      users_active << { name: name, enrollment: enrollment }
    end

    users_active.sort_by! { |user| user[:name] }
  end

  def logged(event, user_logged_in = nil)
    @new_subscription = true

    return unless user_logged_in

    @enrollment = Enrollment.where(event: event, user: user_logged_in).first

    @new_subscription = false if @enrollment

    @the_user_is_speaker = speaker?(event, user_logged_in)

    @open_enrollment = false if @the_user_is_speaker || @authorized
  end

  def speaker?(event, user_logged_in)
    is_speaker = false

    event.schedules.with_includes.each do |schedule|
      next unless schedule.talk?

      schedule.talk.users.each do |user|
        is_speaker = true if user.id == user_logged_in.id
      end
    end

    is_speaker
  end
end
