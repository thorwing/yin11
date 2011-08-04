Feature: admin badges

  Background:
    Given There are minimum seeds data


  Scenario: Only Admin can toggle "disable" of badges.
    Given the following badge exists:
    | name     | description  | contribution_field | comparator | compared_value |
    | 新手上路 | 发表一篇测评 | posted_reviews     | ==          | 1              |
    When I log in as "Ray Admin"
    And I go to the admin badges page
    And I follow "新手上路"
    And I follow "修改"
    And I uncheck "badge_enabled"
    And I press "完成"
    When I go to the badges page
    Then I should not see "新手上路"

    When I go to the admin badges page
    And I follow "新手上路" within "#disabled_badges"
    And I follow "修改"
    And I check "badge_enabled"
    And I press "完成"
    When I go to the admin badges page
    Then I should see "新手上路" within "#enabled_badges"
