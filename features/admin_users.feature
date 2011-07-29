Feature: admin users

  Background:
    Given There are minimum seeds data

  Scenario: Admin can disable a user
    When I log in as "Ray Admin"
    And I go to the admin_users page
    And I follow "David"
    And I follow "编辑"
    And I uncheck "user_enabled"
    And I press "完成"
    When I log out
    And I log in as "David User"
    When I go to the home page
    Then I should not see "个人资料"