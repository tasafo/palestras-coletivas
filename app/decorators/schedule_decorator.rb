class ScheduleDecorator
  def initialize(schedule, params = nil)
    @schedule = schedule
    @params = params
  end

  def create
    @schedule.save
  end

  def update
    @schedule.update(@params)
  end
end
