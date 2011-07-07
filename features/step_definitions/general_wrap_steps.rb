# encoding: utf-8

Given /^I log in as "(.+)"$/ do |name|
  case name
    when "David User"
      email = @normal_user.email
      pwd = @normal_user.password
    when "Kate Tester"
      email = @tester.email
      pwd = @tester.password
    when "Castle Editor"
      email = @editor.email
      pwd = @editor.password
    when "Ray Admin"
      email = @admin.email
      pwd = @admin.password
    else
      assert false
  end

  visit path_to("the log_in page")
  fill_in "email", :with => email
  fill_in "password", :with => pwd
  click_button("登入")
end

Given /^I log in as user$/ do
  visit path_to("the log_in page")
  fill_in "email", :with => "user@yin11.com"
  fill_in "password", :with => "iamtester"
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
  fill_in "search", :with => foods
  click_button "搜索"
end

When /^I search tips for "(.+)"$/ do |item|
  visit path_to("the tips page")
  fill_in "search", :with => item
  click_button "搜索"
end

When /^I fill vendor token field "(.+)" with "(.+)"$/ do |field, name|
  vendor = Vendor.first(conditions: { name: name })
  fill_in field, :with => vendor.id
end

When /^I post a simple review without vendor$/ do
  When %(I go to the home page)
  And %(I follow "发表食物测评" within "#actions_menu")
  And %(I follow "实在想不起在哪儿买的食物了")
  Then %(I should see "新测评")
  And %(I fill a simple review)
end

When /^I fill a simple review$/ do
  When %(I fill in "review_title" with "买到烂西瓜")
  And %(I fill in "review_tags_string" with "西瓜")
  # 过期
  And %(I check "review_faults_4")
  And %(I fill in "review_content" with "西瓜切开来后发现已经熟过头了。")
  And %(I press "完成")
end

When /^I post a simple tip$/ do
    When %(I go to the tips page)
    And %(I follow "创建锦囊")
    And %(I fill in "tip_title" with "辨别西瓜是否含有催熟剂")
    And %(I fill in "tip_content" with "切开西瓜，如果色泽不均匀，而且靠近根部的地方更红，则有可能是使用了催熟剂。")
    And %(I press "完成")
end

When /^I post a simple article$/ do
    When %(I go to the admin_articles page)
    And %(I follow "发表新文章")
    And %(I fill in "article_title" with "土豆刷绿漆，冒充西瓜")
    And %(I fill in "article_content" with "今日，A城警方在B超市，查获了一批疑似用土豆刷上油漆冒充的西瓜。")
    And %(I fill in "article_source_attributes_name" with "神农食品报")
    And %(I fill in "article_tags_string" with "西瓜")
    And %(I fill in "article_region_tokens" with "021")
    And %(I press "完成")
end

When /^I add "(.+)" to watching foods list$/ do |food|
  When %(I fill in "added_foods" with "牛奶")
  And %(I press "添加")
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
