# encoding: utf-8

Given /^There are some sample products$/ do
  @vendor_1 = Factory(:vendor, :name => "天下养鸡网")
  @vendor_2 = Factory(:vendor, :name => "银筷子牧场网")
  @chicken = Product.create(:name => "苏北草母鸡", :price => 18, :weight => "一斤", :tags_string => "禽类，肉类，鸡",  :url => "#", :vendor_id => @vendor_1.id)
  @pig = Product.create(:name => "梅山猪", :price => 25, :weight => "一斤", :tags_string => "肉类，畜类", :url => "#", :vendor_id => @vendor_2.id)
end

Given /^There are more sample products$/ do
  RECOMENDED_PRODUCTS = 3
  Product.create(:name => "东北清香大米", :tags_string => "大米", :url => "#", :vendor_id => @vendor_2.id)
  Product.create(:name => "山西陈醋", :tags_string => "醋", :url => "#", :vendor_id => @vendor_2.id)
end

Given /^There are some sample categories$/ do
  cat = Category.create(:name => "肉类")
  pork = Category.new(:name => "猪肉")
  cat.children << pork
  pork.save
  @pig.category = pork
  @pig.save
end

When /^I view the details of product "(.+)"$/ do |product_name|
  And %(I go to the products page)
  And %(I follow "#{product_name}")
end

When /^I disabled a product named "(.+)"$/ do |product_name|
  And %(I view the details of product "#{product_name}")
  And %(I follow "修改")
  And %(I uncheck "product_enabled")
  And %(I press "完成")
end