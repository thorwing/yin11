Factory.define :review do |f|
  f.sequence(:title) {|n| "test_#{n}"}
  #f.association :author, :factory => :normal_user
end


Factory.define :bad_review, :class => Review  do |f|
  f.sequence(:title) {|n| "milk tastes funny" }
  f.faults [FaultTypes.get_values.first]
  f.tags_string "milk"
  #f.association :author, :factory => :normal_user
end