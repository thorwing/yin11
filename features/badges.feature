#Feature: smoke tests for Badges
#
#  Background:
#    Given There are minimum seeds data
#
#  Scenario: User will get rewards because of posting reviews.
#    Given the following badge exists:
#    | name     | description  | contribution_field | comparator | compared_value |
#    | 新手上路 | 发表一篇分享 | posted_reviews    | >=         | 1              |
#    When I log in as "David User"
#    And I post a simple review without vendor
#
#    When I go to the home page
#    And I follow "徽章" within "#top_menu"
#    Then I should see "(1)"
#
#  Scenario: A admin can create a badge, and it can be given to a user
#    When I log in as "Mighty Admin"
#    And I go to the badges page
#    And I follow "新建"
#    And I fill in "badge_name" with "新手上路"
#    And I fill in "badge_description" with "发表第一篇分享"
#    And I select "posted_reviews" from "badge_contribution_field"
#    And I select "greater_than_or_equals" from "badge_comparator"
#    And I fill in "badge_compared_value" with "1"
#    And I press "完成"
#
#    When I log in as "David User"
#    And I post a simple review without vendor
#
#    When I go to the home page
#    And I follow "徽章" within "#top_menu"
#    Then I should see "(1)"
#
#  Scenario: Only Admin can create badges
#    When I go to the new_badge page
#    Then I should be on the login page
#
#    When I log in as "David User"
#    And I go to the new_badge page
#    Then I should be on the home page
#
#  Scenario: Only Admin can edit badges.
#    Given the following badge exists:
#    | name     | description  | contribution_field | comparator | compared_value |
#    | 新手上路 | 发表一篇分享  | posted_reviews     | ==          | 1              |
#    When I log in as "Mighty Admin"
#    And I go to the administrator_badges page
#    And I follow "新手上路"
#    And I follow "修改"
#    And I fill in "badge_compared_value" with "3"
#    And I press "完成"
#
#    And I log in as "David User"
#    And I go to the badges page
#    And I follow "新手上路"
#    Then I should not see "修改" within "#content_area"
#
#    And I go to the home page
#    And I follow "徽章" within "#top_menu"
#    Then I should not see "×1"
#
#    When I post a simple review without vendor
#    And I go to the home page
#    And I follow "徽章" within "#top_menu"
#    Then I should not see "×1"
#
#
#  Scenario: User can get a badge for first review.
#    Given the following badge exists:
#      | name     | description  | contribution_field  | comparator | compared_value |
#      | 新手上路 | 发表第一篇分享 | posted_reviews    | ==          | 1              |
#
#    When I log in as "David User"
#    And I post a simple review without vendor
#    And I go to David's profile page
#    Then I should see "新手上路"
#
#  Scenario: User can get a badge for his review gets more than 100 votes.
#    Given the following badge exists:
#      | name     | description                     | contribution_field   | comparator | compared_value |
#      | 热门写手 | 发表一篇分享获得100分以上的投票 | highest_review_votes | >=          | 100            |
#    #TODO
#
#
#  Scenario: User can get a badge for first up/down vote
#    Given the following badge exists:
#      | name   | description    | contribution_field | comparator | compared_value |
#      | 批评家 | 投出第一票down | total_down_votes   | ==          | 1              |
#
#    And the following article exists:
#      | title            | content                            | tags_string |
#      | 西瓜被打了催熟剂 | 本报讯，今日很多西瓜都被打了催熟剂 | 西瓜      |
#
#    When I log in as "David User"
#    And I go to the articles page
#    Then I should see "西瓜被打了催熟剂"
#    When I follow "down" within ".item.info"
#
#    When I go to David's profile page
#    Then I should see "批评家"
#
#  Scenario: User can get a badge for leaving 10 comments
#    Given the following badge exists:
#      | name   | description | contribution_field | comparator | compared_value |
#      | 评论者 | 写10条评论 | total_comments     | ==           | 10              |
#
#  Scenario: User can get a badge for for creating first tip
#    Given the following badge exists:
#      | name   | description    | contribution_field | comparator | compared_value |
#      | 学徒   | 创建第一条贴士 | posted_tips       | ==           | 1              |
#
#  Scenario: User can get a badge for for first editing tip
#    Given the following badge exists:
#      | name   | description    | contribution_field | comparator | compared_value |
#      | 纠正者 | 编辑第一条贴士 | edited_tips       | ==           | 1              |
#
#  Scenario: Only Admin can toggle "disable" of badges.
#    Given the following badge exists:
#    | name     | description  | contribution_field | comparator | compared_value |
#    | 新手上路 | 发表一篇分享 | posted_reviews     | ==          | 1              |
#    When I log in as "Mighty Admin"
#    And I go to the administrator_badges page
#    And I follow "新手上路"
#    And I follow "修改"
#    And I uncheck "badge_enabled"
#    And I press "完成"
#    When I go to the badges page
#    Then I should not see "新手上路"
#
#    When I go to the administrator_badges page
#    And I follow "新手上路" within "#disabled_badges"
#    And I follow "修改"
#    And I check "badge_enabled"
#    And I press "完成"
#    When I go to the badges page
#    Then I should see "新手上路"
