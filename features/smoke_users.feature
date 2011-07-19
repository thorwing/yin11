Feature: smoke tests for User
  User can add foods to watching list, so they will be notified about the news of those foods
  User can fill in the detail of their address, so these info will help the search
  User can customize his home page
  User can see his reviews on his profile page

  User can watch(focus) another people (integration with WeiBo)

  Background:
    Given There are minimal testing records


  Scenario: User should not see quick_login on the login page
    When I go to the login page
    Then I should not see "quick_auth"

  Scenario: One can register as a new user
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

  Scenario: Admin can disable a user
    When I log in as "Ray Admin"
    And I go to the admin_users page
    And I follow "David"
    And I follow "禁用"
    When I log out
    And I log in as "David User"
    When I go to the home page
    Then I should not see "David"

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
#    When I post a simple review without vendor
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
    And I post a simple review without vendor
    And I go to the profile page
    Then I should see "买到烂西瓜"

#  Scenario: User can update his profile, and add some places that he is interested in
#    When I log in as "David User"
#    And I go to the profile page
#    Then I should see "感兴趣的地方"

