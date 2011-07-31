module ReviewsHelper
  def check_fault(type, index)
    concat( check_box_tag "review[faults][]", type, @review.faults.include?(type), {:id => "review_faults_#{index}", :class => "checkbox" } )
    concat( label_tag "review_faults_#{index}", type )
    #concat( raw "<br/>") if (index > 0 && (index + 1) % 3 == 0)
  end
end
