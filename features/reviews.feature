@focus
Feature: tests for reviews

  Background:
    Given There are minimum seeds data
    And There are some sample products

  Scenario: Guest can't add review for a product
    When I go to the products page
    And I follow "苏北草母鸡"
    Then I should not see "input" whose id is "review_title"
    And I should not see "input" whose id is "review_content"

  @javascript
  Scenario: User can add review for a product
    When I log in as "David User"
    And I go to the products page
    And I follow "苏北草母鸡"
    Then I should see "input" whose id is "review_title"
    And I should see "input" whose id is "review_content"

    When I fill in "review_title" with "用来炖鸡汤不错"
    And I press "发表测评"
    Then I should see "用来炖鸡汤不错"
    And I should not see "input" whose id is "review_title"
    And I should not see "input" whose id is "review_content"

    When I go to the products page
    And I follow "苏北草母鸡"
    Then I should see "用来炖鸡汤不错"

  Scenario: User can upload image for the review
    When I log in as "David User"
    And I go to the products page
    And I follow "苏北草母鸡"
    Then I should see "object" whose id is "image_uploaderUploader"

  @javascript
  Scenario: User can comments on other user's review
    When I log in as "David User"
    And I post a simple review for "苏北草母鸡" with "用来炖鸡汤不错"

    When I go to the products page
    And I follow "苏北草母鸡"
    Then I should see "用来炖鸡汤不错"

    And I should see "添加评论"
    When I follow "添加评论"
    Then I should see "input" whose id is "content"
    When I fill in "content" with "同意你的观点" within ".new_comment"
    And I press "评论"

    When I log in as "David User"
    And I go to the products page
    And I follow "苏北草母鸡"
    And I follow "1条评论"
    Then I should see "同意你的观点"

  @javascript
  Scenario: User can vote for a review.
    When I log in as "David User"
    And I post a simple review for "苏北草母鸡" with "用来炖鸡汤不错"

    When I log out
    And I log in as "Kate Tester"
    And I go to the products page
    And I follow "苏北草母鸡"
    Then I should see "用来炖鸡汤不错"
    When I follow "up" within ".vote_fields"
    Then I should see "1" within ".vote_fields"





