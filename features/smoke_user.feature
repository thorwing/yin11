Feature: smoke tests for User
  User can add foods to watching list, so they will be notified about the news of those foods
  User can fill in the detail of their address, so these info will help the search
  User can customize his home page

  User can watch(focus) another people (integration with WeiBo)

  Background:
      Given There is a "David User"
      And There is a "Kate Tester"
      And There are minimal testing records

  Scenario: User can add foods to watching list, so they will be notified about the news of those foods
    When I log in as "David User"
    And I search for "牛奶"

    And I should see "为什么要把食物收藏到<我的菜单>"
    And I follow "把牛奶收藏到<我的菜单>"

    When I go to the home page
    Then I should see "三聚氰胺再现上海"

