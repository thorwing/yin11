Feature: test for administrating users
  只有管理员可以管理用户
  访客，注册用户，编辑都不可以管理用户
  管理员可以禁止一个用户
  管理员可以改变其他用户的角色
  管理员也不可以改变他自己的角色

  Background:
    Given There are minimum seeds data

  Scenario: 只有管理员可以管理用户
    When I log in as "Mighty Admin"
    And I go to the administrator_users page
    Then I should be on the administrator_users page

  Scenario Outline: 访客，注册用户，编辑都不可以管理用户
    When I log in as "<user>"
    And I go to the administrator_users page
    Then I should not be on the administrator_users page

    Examples:
    | user |
    | Guest |
    | David User |
    | Castle Editor |

  Scenario: 管理员可以禁止一个用户
    When I log in as "David User"
    And I go to the new_review page
    Then I should be on the new_review page

    When I log out
    And I log in as "Mighty Admin"
    And I go to the administrator_users page
    And I follow "David"
    And I follow "编辑"
    And I uncheck "user_enabled"
    And I press "完成"
    And I log out

    When I log in as "David User"
    When I go to the new_review page
    Then I should not be on the new_review page

  Scenario: 管理员可以改变其他用户的角色
    When I log in as "David User"
    And I go to the new_article page
    Then I should not be on the new_article page

    When I log out
    And I log in as "Castle Editor"
    And I go to the new_article page
    Then I should be on the new_article page

    When I log in as "Mighty Admin"
    And I go to the administrator_users page
    And I follow "David"
    And I follow "编辑"
    And I select "Editor" from "new_role"
    And I press "完成"

    And I go to the administrator_users page
    And I follow "Castle"
    And I follow "编辑"
    And I select "Normal User" from "new_role"
    And I press "完成"
    And I log out

    When I log in as "David User"
    And I go to the new_article page
    Then I should be on the new_article page
    And I log out

    When I log in as "Castle Editor"
    And I go to the new_article page
    Then I should not be on the new_article page

  Scenario: 管理员也不可以改变他自己的角色
    When I log in as "Mighty Admin"
    And I go to the administrator_users page
    Then I should not see "Ray" within "#content_area"