Feature: general usage
  User can do some basic stuff

  Background:
    Given There are minimum seeds data

  Scenario: Admin can disable/enable articles by single click
    Given the following articles exists:
    | title      | content                | enabled |
    | 可疑的文章 | 这是一篇很可疑的文章   | false   |
    When I log in as "Ray Admin"
    When I go to the home page
    Then I should not see "可疑的文章"
    When I go to the admin_articles page
    And I follow "toggle_link" within ".toggle.off"
    And I go to the home page
    Then I should see "可疑的文章"

  Scenario: Admin can recommend/unrecommend articles by single click
    Given the following articles exists:
    | title      | content                |
    | 很棒的文章 | 这是一篇很棒的文章     |
    When I log in as "Ray Admin"
    And I go to the home page
    Then I should see "很棒的文章"
    And I should not see "很棒的文章" within "#articles_frame"
    When I go to the admin_articles page
    And I follow "toggle_link" within ".toggle.off"
    And I go to the home page
    Then I should see "很棒的文章" within "#articles_frame"





