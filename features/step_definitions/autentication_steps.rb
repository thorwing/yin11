When /^I register as a new user "(.+)" with email "(.+)"$/ do |user, email|
    When %(I go to the sign_up page)
    And %(I fill in "user_email" with "#{email}")
    And %(I fill in "user_login_name" with "#{user}")
    And %(I fill in "user_password" with "test123")
    And %(I fill in "user_password_confirmation" with "test123")
    And %(I press "注册")
end
