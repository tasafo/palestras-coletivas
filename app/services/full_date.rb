# :nodoc:
class FullDate
  def initialize(**options)
    options.each { |name, value| instance_variable_set("@#{name}", value) }
  end

  def convert
    if @start_date == @end_date
      "#{I18n.t('titles.events.date.on')} #{locale(@start_date, :long)}"
    elsif @start_date.year != @end_date.year
      years_equal
    elsif @start_date.month == @end_date.month
      months_equal
    else
      general
    end
  end

  private

  def years_equal
    text = "#{@date_of} #{locale(@start_date, :long)} #{@date_to} "
    text << locale(@end_date, :long)
    text
  end

  def months_equal
    text = "#{@date_of} #{@day_one} #{@date_to} #{@day_two} #{@date_of} "
    text << locale(@start_date, @date_format)
    text
  end

  def general
    text = "#{@date_of} #{@day_one} #{@date_of} #{locale(@start_date, '%B')} "
    text << "#{@date_to} #{@day_two} #{@date_of} "
    text << locale(@end_date, @date_format)
    text
  end

  def locale(date, format)
    I18n.l(date, format: format)
  end
end
