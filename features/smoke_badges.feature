Feature: smoke tests for Badges
  A badge can be given to a user.
  Only Admin can create badges.
  Only Admin can edit badges.
  Only Admin can delete badges.
  User can get a badge for first review.
  for 10 reviews.
  for his review gets more than 100 votes.
  for first up/down vote
  for leaving 10 comments
  for create first tip
  for create 10 tips
  for first editing tip
  for create first tag
  for create 5 tags
  for first editing tag
  for create a tip that is collected by more than 100 users.


  Editor can add descriptions on images.
  User can vote fro a article.
  User can comment on a articel, comments can be nested.

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
    Then I should see "1 owners"

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
    Then I should not see "1 owners"

    When I post a sample review
    And I go to the home page
    And I follow "徽章" within "#menu"
    Then I should not see "1 owners"



  Scenario: User will get rewards because of posting reviews.
    Given the following badge exists:
    | name     | description  | contribution_field | comparator | compared_value |
    | 新手上路 | 发表一篇测评 | created_reviews    | 8          | 1              |
    When I log in as "David User"
    And I post a sample review

    When I go to the home page
    And I follow "徽章" within "#menu"
    Then I should see "1"



