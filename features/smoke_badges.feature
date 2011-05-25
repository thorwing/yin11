Feature: smoke tests for Badges
  A badge can be given to a user.
  Only Admin can create badges.
  Only Admin can edit badges.
  Only Admin can disable badges.
  User can get a badge for first review.
  User can get a repeatable badge.
  for 10 reviews.
  for his review gets more than 100 votes.
  for first up/down vote
  for leaving 10 comments
  for creating first tip
  for creating 10 tips
  for first editing tip
  for create first tag
  for create 5 tags
  for first editing tag
  for create a tip that is collected by more than 100 users.

  Background:
    Given There is a "David User"
    And There is a "Kate Tester"
    And There is a "Ray Admin"
    And There are minimal testing records

  Scenario: A admin can create a badge, and it can be given to a user
    When I log in as "Ray Admin"
    And I go to the badges page
    And I follow "新建"
    And I fill in "badge_name" with "新手"
    And I fill in "badge_description" with "发表第一篇测评"
    And I select "created_reviews" from "badge_contribution_field"
    And I select "COMPARISON_GREATER_THAN_OR_EQUAL" from "badge_comparator"
    And I fill in "badge_compared_value" with "1"
    And I press "完成"

    When I log in as "David User"
    And I post a sample review

    When I go to the home page
    And I follow "徽章" within "#menu"
    Then I should see "1 times"

  Scenario: Only Admin can create badges
    When I log in as "David User"
    And I go to the badges page
    Then I should not see "新建"

    When I go to the new_badge page
    Then I should be on the log_in page

  Scenario: Only Admin can edit badges.
    Given the following badge exists:
    | name     | description  | contribution_field | comparator | compared_value |
    | 新手上路 | 发表一篇测评 | created_reviews    | 8          | 1              |
    When I log in as "Ray Admin"
    And I go to the badges page
    And I follow "新手上路"
    And I follow "修改"
    And I fill in "badge_compared_value" with "3"
    And I press "完成"

    And I log in as "David User"
    And I go to the badges page
    And I follow "新手上路"
    Then I should not see "修改"

    And I go to the home page
    And I follow "徽章" within "#menu"
    Then I should not see "1 times"

    When I post a sample review
    And I go to the home page
    And I follow "徽章" within "#menu"
    Then I should not see "1 times"

  Scenario: Only Admin can toggle "disable" of badges.
    Given the following badge exists:
    | name     | description  | contribution_field | comparator | compared_value |
    | 新手上路 | 发表一篇测评 | created_reviews    | 8          | 1              |
    When I log in as "Ray Admin"
    And I go to the badges page
    And I follow "新手上路"
    And I follow "修改"
    And I check "badge_disabled"
    And I press "完成"
    When I go to the badges page
    Then I should not see "新手上路" within "#enabled_badges"

    When I go to the badges page
    And I follow "新手上路" within "#disabled_badges"
    And I follow "修改"
    And I follow "启用"
    When I go to the badges page
    Then I should see "新手上路" within "#enabled_badges"

  Scenario: User can get a badge for first review.
    Given the following badge exists:
      | name     | description  | contribution_field   | comparator | compared_value |
      | 新手上路 | 发表第一篇测评 | created_reviews    | 3          | 1              |

    When I log in as "David User"
    And I post a sample review
    And I go to the profile page
    Then I should see "新手上路"

  Scenario: User can get a repeatable badge.
    Given the following badge exists:
      | name     | description  | contribution_field   | comparator | compared_value | repeatable |
      | 新手上路 | 发表第一篇测评 | created_reviews    | 8          | 1              | true       |

    When I log in as "David User"
    And I post a sample review
    And I go to the profile page
    Then I should see "新手上路"

    And I post a sample review
    And I go to the profile page
    Then I should see "新手上路 2"

  Scenario: User can get a badge for his review gets more than 100 votes.
    Given the following badge exists:
      | name     | description                     | contribution_field   | comparator | compared_value | repeatable |
      | 热门写手 | 发表一篇测评获得100分以上的投票 | highest_review_votes | 8          | 100            | true       |

  Scenario: User can get a badge for first up/down vote
    Given the following badge exists:
      | name   | description    | contribution_field | comparator | compared_value |
      | 批评家 | 投出第一票down | total_down_votes   | 8          | 1              |

    And the following article exists:
      | title            | content                            | food_tokens |
      | 西瓜被打了催熟剂 | 本报讯，今日很多西瓜都被打了催熟剂 | 西瓜      |

    When I log in as "David User"
    Then I should see "西瓜被打了催熟剂"
    When I follow "down" within ".info_item"
    Then I should see "1" within ".info_item"

    When I go to the profile page
    Then I should see "批评家"

  Scenario: User can get a badge for leaving 10 comments
    Given the following badge exists:
      | name   | description | contribution_field | comparator | compared_value |
      | 评论者 | 写10条评论 | total_comments     | 8           | 10              |

  Scenario: User can get a badge for for creating first tip
    Given the following badge exists:
      | name   | description    | contribution_field | comparator | compared_value |
      | 学徒   | 创建第一条贴士 | created_tips       | 8           | 1              |

  Scenario: User can get a badge for for first editing tip
    Given the following badge exists:
      | name   | description    | contribution_field | comparator | compared_value |
      | 纠正者 | 编辑第一条贴士 | edited_tips       | 8           | 1              |