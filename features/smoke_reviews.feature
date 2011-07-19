Feature: smoke tests for Reviews
  User can create, edit(only his own) review.
  User can not delete his review.
  Review is food-oriented, location-oriented
  Review is visible to everyone.
  User will get rewards because of posting reviews.
  User can vote for a review.
  User can comment on a review, comments can be nested.

  Repeat the above steps for tech-review

  Background:
    Given There are minimal testing records

  Scenario: User should get warning of review with no image will be disabled
    When I log in as "David User"
    And I go to the new_review page
    Then I should see "请至少上传一张图片，否则测评将在24小时后被禁用"


  Scenario: User has to choose before creating new review
    When I log in as "David User"
    And I follow "发表食物测评"
    Then I should see "先找到针对的商户"
    Then I should see "实在想不起在哪儿买的食物了"


  Scenario: User can choose a vendor and create a new review against it
    Given the following vendor exists:
    | name       | city |
    | 农工商超市 | 上海 |
    When I log in as "David User"
    And I follow "发表食物测评"
    And I follow "先找到针对的商户"
    And I follow "农工商超市"
    And I follow "+测评"
    Then I should see "新测评"
    Then I should see "农工商超市"

    When I fill a simple review
    And I go to the vendors page
    And I follow "农工商超市"
    Then I should see "所有测评"
    And I should see "买到烂西瓜"

  Scenario: User can skip choosing a vendor, and create a new review
    Given the following vendor exists:
    | name       | city |
    | 农工商超市 | 上海 |
    When I log in as "David User"
    And I follow "发表食物测评"
    And I follow "实在想不起在哪儿买的食物了"
    Then I should see "新测评"
    And I should see "上海"
    And I should see "select" whose id is "review_location_district_id"

    When I fill a simple review
    And I go to the vendors page
    And I follow "农工商超市"
    Then I should see "所有测评"
    And I should not see "买到烂西瓜"

    When I go to the home page
    Then I should see "买到烂西瓜"

  Scenario: User can follow the link from home page and create a review
    When I log in as "David User"
    And I post a simple review without vendor
    And I should see "买到烂西瓜"
    And I should see "过期"
    And I should see "西瓜切开来后发现已经熟过头了。"

  Scenario: User can edit his own review
    When I log in as "David User"
    And I post a simple review without vendor

    When I go to the reviews page
    And I follow "买到烂西瓜"
    And I follow "编辑"
    #has to fill the food again because of the data-pre is skipped in testing
    And I check "review_faults_0"
    And I fill in "review_content" with "而且这个西瓜是打了催熟剂的"
    And I press "完成"
    And I should see "买到烂西瓜"
    And I should see "而且这个西瓜是打了催熟剂的"
    And I should see "添加剂"

#  # should be tested by using spec#routing
#  Scenario: user can't delete his review
#    When I go to the reviews page
#    Then I should not see "删除"
#    When I go to the reviews/123/ page
#    Then I should be on the login page
#
#    When I log in as "Kate Tester"
#    And I go to the reviews/123/edit page
#    Then I should be on the home page
#    And I should see "只有作者才可以执行此操作"

  @javascript
  Scenario: User can vote for a review.
    When I log in as "Kate Tester"
    And I go to the home page
    And I follow "发表食物测评" within "#actions_menu"
    And I follow "实在想不起在哪儿买的食物了"
    And I fill in "review_title" with "买到烂西瓜"
    And I press "完成"

    When I log out
    And I log in as "David User"
    When I follow "up" within ".item.info"
    Then I should see "1" within ".item.info"

  @javascript
  Scenario:  User can comment on a review, comments can be nested.
    Given the following review exists:
    | title      | tags_string  | content |
    | 买到烂西瓜 | 西瓜         | 西瓜切开来后发现已经熟过头了。 |

    When I log in as "Kate Tester"
    Then I should see "买到烂西瓜"
    When I follow "买到烂西瓜"
    And I fill in "content" with "很有用的评价" within ".new_comment"
    And I press "发表评论"
    And I go to the home page
    Then I should see "评论(1)"

    When I log in as "David User"
    When I follow "买到烂西瓜"
    And I fill in "content" with "谢谢" within ".new_comment"
    And I press "发表评论"
    And I go to the home page
    Then I should see "评论(2)"

  Scenario:  User's city will be detected.
    When I log in as "David User"
    And I follow "发表食物测评" within "#actions_menu"
    And I follow "实在想不起在哪儿买的食物了"
    Then I should see "上海"
    And I should see "切换城市"


















