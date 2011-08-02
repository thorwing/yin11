Factory.define :badge do |f|
  f.name "sample badge"
  f.description "just for testing"
  f.contribution_field "test_field"
  f.comparator ">="
  f.compared_value 1
end
