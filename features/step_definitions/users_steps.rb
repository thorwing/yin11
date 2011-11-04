#encoding: utf-8

Given /^I log in as "(.+)"$/ do |name|
  case name
    when "Guest"
      visit root_path
    when "David User" || "David"
      email = @normal_user.email
      pwd = @normal_user.password
    when "Kate Tester" || "Kate"
      email = @tester.email
      pwd = @tester.password
    when "Castle Editor" || "Castle"
      email = @editor.email
      pwd = @editor.password
    when "Mighty Admin" || "Superuser"
      email = @admin.email
      pwd = @admin.password
    else
      assert false
  end

  visit path_to("the login page")
  fill_in "email", :with => email
  fill_in "password", :with => pwd
  click_button("登入")
end

Given /^I log in with email "(.+)" and password "(.+)"$/ do |email, password|
  visit path_to("the login page")
  fill_in "email", :with => email
  fill_in "password", :with => password
  click_button("登入")
end

Given /^I log out$/ do
  visit path_to("the logout page")
end

Given /^"(.+)" follows "(.+)"$/ do |user_name1, user_name2|
  user1 = User.first(conditions: {:login_name => user_name1})
  user2 = User.first(conditions: {:login_name => user_name2})

  user1.add_follower!(user2)
end

