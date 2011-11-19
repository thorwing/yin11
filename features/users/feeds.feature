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
    Given the following vendor exists:
      | name       | city | street |
      | 农工商超市 | 上海 | 大华路 |
    When I log in as "David User"
    And I join the group "西瓜守望者"

    When I log in as "Kate Tester"
    And I post a review about vendor "农工商超市"
    When I go to the reviews page
    Then I should see "买到烂西瓜"

    When I log in as "David User"
    Then I should see "买到烂西瓜"

    When I log in as "Mighty Admin"
    Then I should not see "买到烂西瓜"


