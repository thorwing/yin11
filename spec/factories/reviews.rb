Factory.define :review do |f|
  f.sequence(:title) {|n| "test_#{n}"}
  #f.association :author, :factory => :normal_user
end


Factory.define :bad_review, :class => Review  do |f|
  f.sequence(:title) {|n| "milk tastes funny" }
end