Feature: smoke tests for Review
  User can create, edit(only his own) review.
  User can not delete his review.
  Review is food-oriented, location-oriented
  Review is visible to everyone.
  User will get rewards because of posting reviews.
  User can vote for a review.
  User can comment on a review, comments can be nested.

  Repeat the above steps for tech-review

  Background:
    Given There is a "David User"
    And There is a "Kate Tester"
    And There are minimal testing records

  Scenario: User can post normal review from homepage, and he create a new vendor ( it will be better if we can make a popup window here)
    When I log in as "David User"
    And I post a sample review
    Then I should be on the reviews page
    And I should see "买到烂西瓜"
    And I should see "severity:1"
    And I should see "西瓜切开来后发现已经熟过头了。"

  @focus
  Scenario: User can edit his own review about a existed vendor, and user can't delete his review
    When I log in as "David User"
    And I post a sample review

    When I go to the home page
    And I follow "我的评价" within "#menu"
    Then I should see "买到烂西瓜"
    And I follow "修改"
    #has to fill the food again because of the data-pre is skipped in testing
    And I fill in "review_food_token" with "西瓜"
    And I choose "review_severity_3"
    And I fill in "review_content" with "而且这个西瓜是打了催熟剂的"
    And I press "完成"
    And I should see "买到烂西瓜"
    And I should see "而且这个西瓜是打了催熟剂的"
    And I should see "severity:3"


#  # should be tested by using spec#routing
#  Scenario: user can't delete his review
#    When I go to the reviews page
#    Then I should not see "删除"
#    When I go to the reviews/123/ page
#    Then I should be on the log_in page
#
#    When I log in as "Kate Tester"
#    And I go to the reviews/123/edit page
#    Then I should be on the home page
#    And I should see "只有作者才可以执行此操作"

  Scenario: User can vote for a review.
    When I log in as "David User"
    And I post a sample review

    When I log in as "Kate Tester"
    Then I should see "买到烂西瓜"
    When I follow "up" within ".info_item"
    Then I should see "1" within ".info_item"

  Scenario:  User can comment on a review, comments can be nested.
    When I log in as "David User"
    And I post a sample review

    When I log in as "Kate Tester"
    Then I should see "买到烂西瓜"
    When I follow "查看" within ".info_item"
    And I fill in "content" with "很有用的评价" within ".new_comment"
    And I press "添加"
    And I go to the home page
    Then I should see "1 comments" within ".info_item"

    When I log in as "David User"
    When I follow "查看" within ".info_item"
    And I follow "Reply"
    And I fill in "content" with "谢谢" within ".new_comment"
    And I press "添加"
    And I go to the home page
    Then I should see "2 comments" within ".info_item"

  Scenario: User will get rewards because of posting reviews.
    Given the following badge exists:
    | name     | description  | user_field     | comparator | compared_value |
    | 新手上路 | 发表一篇测评 | posted_reviews | 8          | 1              |
    When I log in as "David User"
    And I post a sample review

    When I go to the home page
    And I follow "徽章" within "#menu"
    Then I should see "1"

  Scenario:  Repeat the above steps for tech-review

















