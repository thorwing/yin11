Feature: tests for general User module
  可以注册为新用户
  注册用户可以看到自己的基本信息

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

  Scenario Outline: 注册用户可以看到自己的基本信息
    Given There are some products
    When I log in as "<user>"
    #later Kate will visit the user via this review
    And I post a simple review for "梅山猪" with "发现了上好的猪肉"
    And I go to the me page
    And I follow "<user_name>" within "#user_panel"
    Then I should be on <user_name>'s profile page
    And I should see "基本信息"
    When I log out
    And I log in as "Kate Tester"
    And I go to the reviews page
    And I follow "<user_name>"
    Then I should be on <user_name>'s user page
    And I should not see "基本信息"

    Examples:
    | user          | user_name |
    | David User    | David    |
    | Castle Editor | Castle   |
    | Mighty Admin  | Ray      |

