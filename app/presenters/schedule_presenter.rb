class SchedulePresenter
  attr_reader :dates, :talk_title, :display

  def initialize(schedule, event)
    event_dates = (event.start_date..event.end_date).to_a

    @dates = prepare_dates(event_dates, schedule)

    schedule_talk = schedule.talk

    @talk_title = schedule_talk ? schedule_talk.title : ''

    @display = schedule_talk ? 'block' : 'none'
  end

  private

  def prepare_dates(event_dates, schedule)
    dates = ''

    event_dates.each_with_index do |date, index|
      day = index + 1
      selected = schedule.day == day ? "selected='selected'" : ''

      dates << "<option value='#{day}' #{selected}>#{date}</option>"
    end

    dates
  end
end
