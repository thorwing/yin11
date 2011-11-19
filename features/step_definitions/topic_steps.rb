# encoding: utf-8

Given /^There are some topics$/ do
  Topic.create!(:title => "冬令进补", :tags_string => "鸡,鸭,鱼,猪肉")
end