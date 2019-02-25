#:nodoc:
class EventPresenter
  attr_reader :event, :grids, :authorized, :open_enrollment,
              :can_record_presence, :show_users_present, :users_present,
              :users_active, :crowded, :new_subscription, :enrollment, :can_vote

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

    @grids = mount_grid(event)
    @open_enrollment = event.deadline_date_enrollment >= Date.today
    users = prepare_users(event)
    @users_present = users[:presents]
    @users_active = users[:actives]
    @crowded = @users_active.size >= event.stocking
    logged event, user_logged_in
    @can_vote = prepare_can_vote(event)
    prepare_authorized(event, authorized)
  end

  def prepare_authorized(event, authorized)
    @event = event
    @authorized = authorized

    @can_record_presence = record_presence?
    @show_users_present = users_present?

    return if event.to_public

    @event = nil unless @authorized
  end

  def record_presence?
    @authorized && Date.today >= @event.start_date
  end

  def users_present?
    Date.today > @event.end_date && !@can_record_presence
  end

  def prepare_can_vote(event)
    event&.accepts_submissions && event.end_date >= Date.today
  end

  def prepare_users(event)
    hash = add_in_hash(event)
    presents = hash[:presents]
    actives = hash[:actives]

    presents.sort_by!(&:slug)

    actives.sort_by! { |user| user[:user].slug }

    fields_hash(presents, actives)
  end

  def add_in_hash(event)
    presents = []
    actives = []

    event.enrollments.with_user.each do |enrollment|
      presents << enrollment.user if enrollment.present?

      if enrollment.active?
        actives << { user: enrollment.user, enrollment: enrollment }
      end
    end

    fields_hash(presents, actives)
  end

  def fields_hash(presents, actives)
    { presents: presents, actives: actives }
  end

  def logged(event, user_logged_in = nil)
    @new_subscription = true

    return unless user_logged_in

    @enrollment = Enrollment.where(event: event, user: user_logged_in).first

    @new_subscription = false if @enrollment

    @open_enrollment = false if speaker?(event, user_logged_in) || @authorized
  end

  def speaker?(event, user_logged_in)
    is_speaker = false

    schedules = event.schedules.includes(:talk).not_in(talk_id: nil)

    schedules.each do |schedule|
      talk = Talk.with_users.find(schedule.talk)
      talk.users.each do |user|
        is_speaker = (user.id == user_logged_in.id)
      end
    end

    is_speaker
  end

  def mount_grid(event)
    dates = (event.start_date..event.end_date).to_a

    schedules = event.schedules.with_relations.asc(:day).asc(:time)
                     .desc(:counter_votes)

    add_in_grid(dates, schedules)
  end

  def add_in_grid(dates, schedules)
    grids = []

    dates.each_with_index do |date, index|
      selects = schedules.select { |schedule| schedule.day == index + 1 }

      grids << { date: date, schedules: selects } unless selects.blank?
    end

    grids
  end
end
