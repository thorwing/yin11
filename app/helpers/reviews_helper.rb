module ReviewsHelper
  def check_fault(type, index)
    concat( check_box_tag "review[faults][]", type, @review.faults.include?(type), {:id => "review_faults_#{index}", :class => "checkbox" } )
    concat( label_tag "review_faults_#{index}", type )
    #concat( raw "<br/>") if (index > 0 && (index + 1) % 3 == 0)
  end

  def get_severity_of(review)
    n = review.faults.size
    if n == 0
      "zero"
    elsif n == 1
      "one"
    elsif n == 2
      "two"
    else
      "three"
    end
  end
end
