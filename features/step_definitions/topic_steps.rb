# encoding: utf-8

Given /^There are some sample topics$/ do
  Topic.create!(:title => "冬令进补", :tags_string => "鸡,鸭,鱼,肉")
end