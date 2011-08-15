module HomeHelper
  def counter(number)
    if number < 1
      severity = "fine"
    elsif number < 3
      severity = "caution"
    elsif number < 5
      severity = "warning"
    else
      severity = "terrible"
    end

    severity
  end
end