Feature: smoke tests for User
  User can add foods to watching list, so they will be notified about the news of those foods
  User can fill in the detail of their address, so these info will help the search
  User can customize his home page
  User can see his reviews on his profile page

  User can watch(focus) another people (integration with WeiBo)

  Background:
    Given  There is a "David User"
    And There are minimal testing records

  Scenario: User can add foods to watching list, so they will be notified about the news of those foods
    When I log in as "David User"
    And I add "牛奶" to watching foods list

    When I go to the home page
    Then I should see "三聚氰胺再现上海"

  Scenario Outline: User can fill in the detail of their address, so these info will affect infos on the home page
    When I log in as "David User"
    And I add "牛奶" to watching foods list

    And I go to the profile page
    And I follow "修改"
    And I press "完成"
    And I go to the home page
    #Then I should see "三聚氰胺再现上海" within "<container>"
    Then I should see "三聚氰胺再现上海"

    Examples:
      | city_id | container    |
      | 021     | #info_item_0 |
      | 010     | #info_item_1 |

#  Scenario: User can customize his home page
#    When I log in as "David User"
#    And I add "牛奶" to watching foods list
#    And I add "西瓜" to watching foods list
#
#    When I go to the home page
#    Then I should see "三聚氰胺再现上海"
#
#    When I go to the profile page
#    And I follow "修改"
#    And I uncheck "profile_display_articles"
#    And I press "完成"
#    And I go to the home page
#    Then I should not see "三聚氰胺再现上海"
#
#    When I post a sample review
#    And I go to the home page
#    Then I should see "买到烂西瓜"
#
#    When I go to the profile page
#    And I follow "修改"
#    And I uncheck "profile_display_reviews"
#    And I press "完成"
#    And I go to the home page
#    Then I should not see "David 报告 上海 大华二路 XX水果超市 的 西瓜 :"

  Scenario: User can see his reviews on his profile page
    When I log in as "David User"
    And I post a sample review
    And I go to the profile page
    Then I should see "买到烂西瓜"

#  Scenario: User can update his profile, and add some places that he is interested in
#    When I log in as "David User"
#    And I go to the profile page
#    Then I should see "感兴趣的地方"

