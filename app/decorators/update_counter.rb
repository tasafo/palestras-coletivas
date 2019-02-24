#:nodoc:
module UpdateCounter
  def set_counter(field, operation)
    field = "counter_#{field}"

    if operation == :inc
      self[field] = self[field] + 1
    elsif operation == :dec
      self[field] = self[field] - 1 if self[field].positive?
    end

    save
  end
end
