Feature: tests for Feeds
  用户可以在“我的首页”看到动态信息，包括:所有动态，我的关注等
  用户可以看到所加入餐桌的其它用户的动态

  Background:
    Given There are minimum seeds data
    And There are some sample groups

  Scenario: 用户可以在“我的首页”看到动态信息
    When I log in as "David User"
    And I go to the me page
    Then I should see "div" whose "id" is "feeds"
    And I should see "用户动态"

  Scenario: 用户可以看到所加入餐桌的其它用户的动态
    Given There are some sample products
    When I log in as "David User"
    And I join the group "肉食爱好者"

    When I log in as "Kate Tester"
    And I join the group "肉食爱好者"
    And I post a simple review for "梅山猪" with "买到烂猪肉"
    When I go to the reviews page
    Then I should see "买到烂猪肉"

    When I log in as "David User"
    And I go to the me page
    Then I should see "买到烂猪肉"

    When I log in as "Castle Editor"
    And I go to the me page
    Then I should not see "买到烂猪肉"


