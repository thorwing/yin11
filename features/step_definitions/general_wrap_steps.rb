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

When /^I search tips for "(.+)"$/ do |item|
  visit path_to("the tips page")
  fill_in "search", :with => item
  click_button "搜索"
end

When /^I post a sample review$/ do
  When %(I go to the home page)
  And %(I follow "新测评" within "#new_review")
  And %(I fill in "review_food_token" with "西瓜")
  And %(I select "上海" from "review_vendor_city")
  And %(I fill in "review_vendor_street" with "大华二路")
  And %(I fill in "review_vendor_name" with "XX水果超市")
  And %(I choose "review_severity_1")
  And %(I fill in "review_content" with "西瓜切开来后发现已经熟过头了。")
  And %(I press "完成")
end

When /^I post a sample tip$/ do
    When %(I go to the tips page)
    And %(I fill in "search" with "辨别西瓜是否含有催熟剂")
    And %(I press "搜索")
    When %(I follow "食物测评贴士: <辨别西瓜是否含有催熟剂>")
    And %(I fill in "content" with "切开西瓜，如果色泽不均匀，而且靠近根部的地方更红，则有可能是使用了催熟剂。")
    And %(I press "完成")
end

When /^I add "(.+)" to watching foods list$/ do |food|
    When %(I search for "#{food}")
    Then %(I should see "为什么要把食物收藏到<我的菜单>")
    And %(I follow "把#{food}收藏到<我的菜单>")
end