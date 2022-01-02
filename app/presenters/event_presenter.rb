class EventPresenter
  attr_reader :event, :grids, :authorized, :open_enrollment,
              :can_record_presence, :show_users_present, :users_present,
              :users_active, :crowded, :new_subscription, :enrollment, :can_vote

  def initialize(event, authorized, user_logged = nil)
    @event = event
    @authorized = authorized
    @user_logged = user_logged

    prepare_event
  end

  def show_checkin
    !@event.block_presence && @enrollment&.active? && Date.today >= @event.start_date
  end

  def address
    EventPolicy.new(@event).address
  end

  def in_progress?
    EventPolicy.new(@event).in_progress?
  end

  private

  def prepare_event
    return unless @event

    @grids = mount_grid

    @open_enrollment = @event.deadline_date_enrollment >= Date.today

    users = prepare_users
    @users_present = users[:presents]
    @users_active = users[:actives]

    @crowded = @users_active.size >= @event.stocking

    logged

    @can_vote = prepare_can_vote

    prepare_authorized
  end

  def prepare_authorized
    today = Date.today
    @can_record_presence = @authorized && today >= @event.start_date
    @show_users_present = today > @event.end_date && !@can_record_presence

    return if @event.to_public

    @event = nil unless @authorized
  end

  def prepare_can_vote
    @event&.accepts_submissions && @event.end_date >= Date.today
  end

  def prepare_users
    hash = add_in_hash
    presents = hash[:presents]
    actives = hash[:actives]

    presents.sort_by!(&:slug)

    actives.sort_by! { |user| user[:user].slug }

    fields_hash(presents, actives)
  end

  def add_in_hash
    presents = []
    actives = []

    @event.enrollments.with_user.each do |enrollment|
      user = enrollment.user

      presents << user if enrollment.present?

      actives << { user: user, enrollment: enrollment } if enrollment.active?
    end

    fields_hash(presents, actives)
  end

  def fields_hash(presents, actives)
    { presents: presents, actives: actives }
  end

  def logged
    @new_subscription = true

    return unless @user_logged

    @enrollment = @event.enrollments
                        .select { |enrollment| enrollment.user_id == @user_logged.id }
                        .first

    @new_subscription = false if @enrollment

    @open_enrollment = false if speaker? || @authorized
  end

  def speaker?
    schedules = @event.schedules.with_talk.select(&:talk_id)

    schedules.each do |schedule|
      schedule.talk.users.each do |user|
        return true if user == @user_logged
      end
    end

    false
  end

  def mount_grid
    dates = (@event.start_date..@event.end_date).to_a

    schedules = @event.schedules.with_relations.order(day: :asc, time: :asc, counter_votes: :desc)

    add_in_grid(dates, schedules)
  end

  def add_in_grid(dates, schedules)
    grids = []

    dates.each_with_index do |date, index|
      selects = schedules.select { |schedule| schedule.day == index + 1 }

      grids << { date: date, schedules: selects } if selects.any?
    end

    grids
  end
end
