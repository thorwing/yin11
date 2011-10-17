Feature:
  User can view another user's basic information.

  Background:
    Given There are minimum seeds data


  Scenario: User can see his own personal page, when others view that page, it will display the brief info
    When I log in as "David User"
    And I follow "David" within "#user_panel"
    Then I should be on David's profile page
    And I should see "基本信息"
    And I should see "偏好设定"
    And I post a simple review without vendor
    When I log out
    And I log in as "Kate Tester"
    And I go to the reviews page
    And I follow "David"
    Then I should be on David's user page
    And I should not see "基本信息"


  Scenario: User's name will be displayed in the item, and others can click the link to view his profile
    When I log in as "David User"
    And I post a simple review without vendor
    When I log out
    And I log in as "Kate Tester"
    And I go to the reviews page
    Then I should see "买到烂西瓜"
    And I should see "David"
    When I follow "买到烂西瓜"
    Then I should see "David"
    When I follow "David"
    Then I should be on David's user page
    And I should see "David"
    And I follow "+关注"