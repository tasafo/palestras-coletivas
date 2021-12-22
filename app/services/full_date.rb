class FullDate
  def initialize(**options)
    options.each { |name, value| instance_variable_set("@#{name}", value) }
  end

  def convert
    if @start_date == @end_date
      "#{I18n.t('titles.events.date.on')} #{date_localized(@start_date, :long)}"
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
    "#{@date_of} #{date_localized(@start_date, :long)} \
    #{@date_to} #{date_localized(@end_date, :long)}"
  end

  def months_equal
    "#{@date_of} #{@day_one} #{@date_to} #{@day_two} #{@date_of} \
    #{date_localized(@start_date, @date_format)}"
  end

  def general
    "#{@date_of} #{@day_one} #{@date_of} #{date_localized(@start_date, '%B')} \
    #{@date_to} #{@day_two} #{@date_of} #{date_localized(@end_date, @date_format)}"
  end

  def date_localized(date, format)
    I18n.l(date, format: format)
  end
end
