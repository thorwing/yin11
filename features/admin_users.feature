Feature: admin users

  Background:
    Given There are minimum seeds data

  Scenario: Admin can disable a user
    When I log in as "Mighty Admin"
    And I go to the administrator_users page
    And I follow "David"
    And I follow "编辑"
    And I uncheck "user_enabled"
    And I press "完成"
    When I log out
    And I log in as "David User"
    When I go to the home page
    Then I should not see "个人资料"

  Scenario: Only Admin can manage users
    When I go to the administrator_users page
    Then I should be on the login page

    When I log in as "Kate Tester"
    Then I should be on the home page
    And I go to the administrator_users page
    Then I should be on the home page

    When I log in as "Castle Editor"
    Then I should be on the home page
    And I go to the administrator_users page
    Then I should be on the home page

    When I log in as "Mighty Admin"
    Then I should be on the administrator_users page

  Scenario: Admin can change other user's role
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
    Then I should be on the home page

  Scenario: Admin can't edit himself's role
    When I log in as "Mighty Admin"
    And I go to the administrator_users page
    Then I should not see "Ray" within "#content_area"