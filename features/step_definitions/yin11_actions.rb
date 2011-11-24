# encoding: utf-8

Then /^"([^"]*)" should be selected for "([^"]*)"(?: within "([^\"]*)")?$/ do |value, field, selector|
  with_scope(selector) do
    field_labeled(field).find(:xpath, ".//option[@selected = 'selected'][text() = '#{value}']").should be_present
  end
end

When /^I search for "(.+)"$/ do |query|
  visit path_to("the home page")
  fill_in "query", :with => query
  click_button "搜索"
end

When /^I query for "(.+)"$/ do |query|
  visit("/search/?query=#{URI.escape(query)}")
end

When /^I search tips for "(.+)"$/ do |item|
  visit path_to("the tips page")
  fill_in "q", :with => item
  click_button "搜索"
end

When /^I fill vendor token field "(.+)" with "(.+)"$/ do |field, name|
  vendor = Vendor.first(conditions: { name: name })
  fill_in field, :with => vendor.id
end

When /^I post a simple review for "(.+)" with "(.+)"$/ do |product_name, content|
  And %(I go to the products page)
  And %(I follow "#{product_name}")

  When %(I fill in "review_content" with "#{content}")
  And %(I press "发表分享")
end

When /^I create a simple vendor$/ do
    When %(I go to the new_vendor page)
    And %(I fill in "vendor_name" with "农工商超市")
    And %(I fill in "vendor_street" with "大华二路")
    And %(I press "完成")
end

When /^I add "(.+)" to watching foods list$/ do |tag|
  When %(I fill in "tags" with "#{tag}" within "#control_panel")
  And %(I press "添加" within "#control_panel")
end
#
#When /^I fill in "(.+?)" with "(.+?)" by Selenium$/ do |field, value|
#    selenium.type field, value
#end

When /^I join the group "(.+)"$/ do |group|
  And %(I go to the groups page)
  And %(I follow "#{group}")
  And %(I follow "加入")
end

Then /^Confirm that "(.+)" is in the group "(.+)"$/ do |user, group|
  When %(I go to #{user}'s profile page)
  Then %(I should see "#{group}" within "#joined_groups")
end

Then /^Confirm that "(.+)" is not in the group "(.+)"$/ do |user, group|
  When %(I go to #{user}'s profile page)
  Then %(I should not see "#{group}" within "#joined_groups")
end

When /^I follow "(.+)" of kind "(.+)"$/ do |name, index|
  When %(I go to the #{index} page)
  And %(I follow "#{name}")
end

When /^I "(.+)" the "(.+)" of kind "(.+)"$/ do |do_what, name, index|
  When %(I follow "#{name}" of kind "#{index}")
  And %(I follow "#{do_what}")
end

Then /^I can't "(.+)" "(.+)" of kind "(.+)"$/ do |do_what, name, index|
  When %(I follow "#{name}" of kind "#{index}")
  Then %(I should not see "#{do_what}")
end
