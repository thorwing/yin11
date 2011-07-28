class EvaluationManager
  def self.evaluate_items(items)
    severity_score = (items.size > 0) ?  items.inject(0){ |sum, s| sum + 1 } / items.size : 0

    if severity_score < 1
      severity_level = 0
    elsif severity_score < 5
      severity_level = 1
    elsif severity_score < 10
      severity_level = 2
    else
      severity_level = 3
    end

     I18n.translate("general.severity_#{severity_level}")
  end
end