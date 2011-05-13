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