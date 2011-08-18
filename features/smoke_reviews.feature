Feature: smoke tests for Reviews
  User can create, edit(only his own) review.
  User can not delete his review.
  Review is food-oriented, location-oriented
  Review is visible to everyone.
  User will get rewards because of posting reviews.

  Repeat the above steps for tech-review

  Background:
    Given There are minimum seeds data

  @focus
  Scenario: User can choose a vendor and create a new review against it
    Given the following vendor exists:
    | name       | city | street | enabled |
    | 农工商超市 | 上海 | 大华路 | true    |
    When I log in as "David User"
    And I follow "找商户"
    And I follow "农工商超市"
    And I follow "+测评" within ".actions"
    Then I should see "新测评"
    Then I should see "农工商超市"

    When I fill a simple review
    And I go to the vendors page
    And I follow "农工商超市"
    Then I should see "所有测评"
    And I should see "买到烂西瓜"

  Scenario: User can skip choosing a vendor, and create a new review
    Given the following vendor exists:
    | name       | city | street |
    | 农工商超市 | 上海 | 大华路 |
    When I log in as "David User"
    And I follow "+测评"
    Then I should be on the new_review page
    And I should see "新测评"

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


  Scenario:  User's city will be detected.
    When I go to the home page
    Then I should see "上海" within "#current_city_name"


















