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
    And I should see "David 报告 上海 大华二路 XX水果超市 的 西瓜 :"
    And I should see "severity:1"
    And I should see "西瓜切开来后发现已经熟过头了。"

  Scenario: User can edit his own review about a existed vendor, and user can't delete his review
    When I log in as "David User"
    And I post a sample review

    When I go to the home page
    And I follow "我的评价" within "#menu"
    Then I should see "上海 大华二路 XX水果超市 的 西瓜"
    And I follow "修改"
    Then I choose "review_severity_3"
    And I fill in "review_content" with "而且这个西瓜是打了催熟剂的"
    And I press "完成"
    Then I should be on the reviews page
    Then show me the page
    And I should see "David 报告 上海 大华二路 XX水果超市 的 西瓜 :"
    And I should see "而且这个西瓜是打了催熟剂的"
    And I should see "severity:3"

    When I go to the reviews page
    Then I should not see "删除"
    When I go to the reviews/123/destory page
    Then I should be on the log_in page

    When I log in as "Kate Tester"
    And I go to the reviews/123/edit page
    Then I should be on the home page
    And I should see "只有作者才可以执行此操作"

  @focus
  Scenario: User can vote for a review.
    When I log in as "David User"
    And I post a sample review

    When I log in as "Kate Tester"
    Then I should see "David 报告 上海 大华二路 XX水果超市 的 西瓜 :"
    When I follow "up" within ".review_item"
    Then I should see "1" within ".review_item"

  @focus
  Scenario:  User can comment on a review, comments can be nested.
    When I log in as "David User"
    And I post a sample review

    When I log in as "Kate Tester"
    Then I should see "David 报告 上海 大华二路 XX水果超市 的 西瓜 :"
    When I follow "查看" within ".review_item"
    And I fill in "review_commnet" with "很有用的评价"
    And I press "添加"
    Then I should see "1 comment" within ".review_item"

    When I log in as "David User"
    When I follow "查看" within ".review_item"
    And I fill in "review_commnet" with "谢谢"
    And I press "添加"
    Then I should see "2 comment" within ".review_item"

  @focus
  Scenario: User will get rewards because of posting reviews.
    Given There is a basic badge
    When I log in as "David User"
    And I post a sample review

    When I go to the home page
    And I follow "徽章" within "#menu"
    Then I should see "新手徽章" within "#my_badges"

  @focus
  Scenario:  Repeat the above steps for tech-review

















