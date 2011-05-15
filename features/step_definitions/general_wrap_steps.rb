# encoding: utf-8

Given /^I log in as "(.+)"$/ do |name|
  email, password, login_name, role = generate_user_info(name)

  visit path_to("the log_in page")
  fill_in "email", :with => email
  fill_in "password", :with => password
  click_button("登入")
end

Given /^I log out$/ do
  visit path_to("the logout page")
end

Then /^I should see "(.+)" whose id is "(.+)"$/ do |element_type, id|
  page.has_xpath?("//#{element_type}[@id='#{id}']")
end

When /^I search for "(.+)"$/ do |foods|
  visit path_to("the home page")
  fill_in "foods", :with => foods
  click_button "搜索"
end

When /^I search wiki for "(.+)"$/ do |item|
  visit path_to("the wiki page")
  fill_in "query", :with => item
  click_button "搜索"
end

When /^I post a sample review$/ do
  When %(I go to the home page)
  And %(I follow "新评价" within "#new_review")
  And %(I fill in "review_food_token" with "西瓜")
  And %(I select "上海" from "review_vendor_city")
  And %(I fill in "review_vendor_street" with "大华二路")
  And %(I fill in "review_vendor_name" with "XX水果超市")
  And %(I choose "review_severity_1")
  And %(I fill in "review_content" with "西瓜切开来后发现已经熟过头了。")
  And %(I press "完成")
end