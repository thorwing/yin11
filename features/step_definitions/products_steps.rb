# encoding: utf-8

Given /^There are some sample products$/ do
  vendor_1 = Factory(:vendor, :name => "南京养鸡场", :city => "南京", :street => "unknown")
  vendor_2 = Factory(:vendor, :name => "银筷子牧场", :city => "上海", :street => "unknown")
  Product.create(:name => "苏北草母鸡", :tags_string => "禽类，肉类，鸡", :url => "#", :vendor_id => vendor_1.id)
  Product.create(:name => "梅山猪", :tags_string => "肉类，畜类", :url => "#", :vendor_id => vendor_2.id)
end

When /^I view the details of product "(.+)"$/ do |product_name|
  And %(I go to the products page)
  And %(I follow "#{product_name}")
end
