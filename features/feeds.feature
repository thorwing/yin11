
Feature: tests for Feeds

  Background:
    Given There are minimum seeds data
    And There are some sample groups

  Scenario: Group member will get feeds regarding the group
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

    When I log in as "Ray Admin"
    Then I should not see "买到烂西瓜"


