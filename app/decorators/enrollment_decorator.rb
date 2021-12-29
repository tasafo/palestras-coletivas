class EnrollmentDecorator
  def initialize(enrollment, option_type, params = nil)
    @enrollment = enrollment
    @option_type = option_type
    @params = params
  end

  def create
    enrollment = Enrollment.find_by(event: @enrollment.event, user: @enrollment.user)

    return false if enrollment

    @enrollment.save
    @enrollment
  end

  def update
    @enrollment.update(@params)
  end
end
