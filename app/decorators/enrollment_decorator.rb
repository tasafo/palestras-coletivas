class EnrollmentDecorator
  OPTIONS = [
    active: {event: :enrollment_events, user: :registered_users},
    present: {event: :participation_events, user: :present_users}
  ]

  def initialize(enrollment, option_type, params = nil)
    @enrollment = enrollment
    @option_type = option_type
    @params = params
  end

  def create
    enrollment = Enrollment.find_by event: @enrollment.event,
      user: @enrollment.user

    return false if enrollment

    @enrollment.save && update_counter_of_events_and_users
    @enrollment
  end

  def update
    @enrollment.update(@params) && update_counter_of_events_and_users
  end

private

  def update_counter_of_events_and_users
    condition = if @option_type == 'active'
                  @enrollment.active?
                else
                  @enrollment.present?
                end
    operation = condition ? :inc : :dec

    @enrollment.user.set_counter(OPTIONS[0][@option_type.to_sym][:event],
      operation)
    @enrollment.event.set_counter(OPTIONS[0][@option_type.to_sym][:user],
      operation)

    true
  end
end
