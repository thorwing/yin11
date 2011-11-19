Feature: tests for general User module
  可以注册为新用户
  用户可以看到其他用户的基本信息

  Background:
    Given There are minimum seeds data

  Scenario: 可以注册为新用户
    When I go to the new_user page
    And I fill in "user_email" with "test_regiser@yin11.com"
    And I fill in "user_password" with "simplepassword"
    And I fill in "user_password_confirmation" with "simplepassword"
    And I press "注册"
    When I go to the login page
    And I fill in "email" with "test_regiser@yin11.com"
    And I fill in "password" with "simplepassword"
    And I press "登入"
    Then I should see "div" whose id is "control_panel"

  Scenario: 用户可以看到其他用户的基本信息
    Given There are some products
    When I log in as "David User"
    #later Kate will visit David via this review
    And I post a simple review for "梅山猪" with "发现了上好的猪肉"
    And I go to the me page
    And I follow "David" within "#user_panel"
    Then I should be on David's profile page
    And I should see "基本信息"
    And I should see "偏好设定"
    When I log out
    And I log in as "Kate Tester"
    And I go to the reviews page
    And I follow "David"
    Then I should be on David's user page
    And I should not see "基本信息"
