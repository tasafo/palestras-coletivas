class EnrollmentDecorator
  def initialize(enrollment, option_type, params = nil)
    @enrollment = enrollment
    @option_type = option_type
    @params = params
  end

  def create
    enrollment = @enrollment.event.enrollments.find_by(user: @enrollment.user)

    return false if enrollment

    @enrollment.save
    @enrollment
  end

  def update
    @enrollment.update(@params)
  end
end
