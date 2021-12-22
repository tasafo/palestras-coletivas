class SchedulePresenter
  attr_reader :activities, :dates, :talk_title, :display

  def initialize(schedule, event)
    @activities = Activity.all.asc(:order)

    event_dates = (event.start_date..event.end_date).to_a

    @dates = prepare_dates(event_dates, schedule)

    @talk_title = schedule.talk? ? schedule.talk.title : ''

    @display = schedule.talk? ? 'block' : 'none'
  end

  private

  def prepare_dates(event_dates, schedule)
    dates = ''
    day = 1

    event_dates.each do |date|
      selected = schedule.day == day ? "selected='selected'" : ''

      dates << "<option value='#{day}' #{selected}>#{date}</option>"
      day += 1
    end

    dates
  end
end
