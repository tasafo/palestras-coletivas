module UpdateCounter
  def set_counter(field, operation)
    field = "counter_#{field}"

    case operation
    when :inc
      self[field] += 1
    when :dec
      self[field] -= 1 if self[field].positive?
    end

    save
  end
end
