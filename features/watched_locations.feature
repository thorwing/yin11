Feature: smoke tests for Profile

  Background:
    Given There are minimum seeds data

  Scenario: User will get a watched location by default
    When I go to the new_user page
    And I fill in "user_login_name" with "tester"
    And I fill in "user_email" with "test_regiser@yin11.com"
    And I fill in "user_password" with "simplepassword"
    And I fill in "user_password_confirmation" with "simplepassword"
    And I press "注册"
    When I go to the login page
    And I fill in "email" with "test_regiser@yin11.com"
    And I fill in "password" with "simplepassword"
    And I press "登入"
    Then I should see "上海 市中心" within "#control_panel"

