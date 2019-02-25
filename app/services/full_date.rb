#:nodoc:
class FullDate
  def initialize(options = {})
    @date1 = options[:date1]
    @date2 = options[:date2]
    @date_of = options[:date_of]
    @date_to = options[:date_to]
    @date_format = options[:date_format]
    @day_one = options[:day_one]
    @day_two = options[:day_two]
  end

  def convert
    if @date1 == @date2
      "#{I18n.t('titles.events.date.on')} #{locale(@date1, :long)}"
    elsif @date1.year != @date2.year
      years_equal
    elsif @date1.month == @date2.month
      months_equal
    else
      general
    end
  end

  private

  def years_equal
    text = "#{@date_of} #{locale(@date1, :long)} #{@date_to} "
    text << locale(@date2, :long)
    text
  end

  def months_equal
    text = "#{@date_of} #{@day_one} #{@date_to} #{@day_two} #{@date_of} "
    text << locale(@date1, @date_format)
    text
  end

  def general
    text = "#{@date_of} #{@day_one} #{@date_of} #{locale(@date1, '%B')} "
    text << "#{@date_to} #{@day_two} #{@date_of} "
    text << locale(@date2, @date_format)
    text
  end

  def locale(date, format)
    I18n.l(date, format: format)
  end
end
