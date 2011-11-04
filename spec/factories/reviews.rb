Factory.define :review do |f|
  f.sequence(:title) {|n| "test_#{n}"}
  #f.association :author, :factory => :normal_user
end