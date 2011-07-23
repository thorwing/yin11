Factory.define :review do |f|
  f.sequence(:title) {|n| "test_#{n}"}
  f.region_ids ["021"]
  #f.association :author, :factory => :normal_user
end
