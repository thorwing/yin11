Feature: tests for Groups

  Background:
    Given There are minimum seeds data
    And There are some sample groups

  Scenario: Guest can visit a group
    When I go to the groups page
    And I should see "西瓜守望者"

  Scenario: Only Admin can create a group
    When I go to the new_group page
    Then I should be on the login page

    When I log in as "David User"
    And I go to the new_group page
    Then I should be on the home page

    When I log in as "Ray Admin"
    And I go to the new_group page
    Then I should be on the new_group page
    When I fill in "group_name" with "小龙虾搜查队"
#   And I fill in "group_tags_string" with "小龙虾"
    And I press "完成"
    When I go to the groups page
    Then I should see "小龙虾搜查队"

  Scenario: User can join a group
    When I log in as "David User"
    And I join the group "西瓜守望者"
    Then I should see "离席"
    Then Confirm that "David" is in the group "西瓜守望者"

  Scenario: User can quit a group
    When I log in as "David User"
    And I join the group "西瓜守望者"
    And I go to David's profile page
    And I follow "西瓜守望者"
    And I follow "离席"
    Then Confirm that "David" is not in the group "西瓜守望者"

  Scenario: Group member can post a topic for his group
    When I log in as "David User"
    And I join the group "西瓜守望者"
    And I go to the groups page
    And I follow "西瓜守望者"
    When I follow "+话题"
    And I fill in "post_title" with "我发现了一个很好的卖西瓜的地方"
    And I fill in "post_content" with "这个地方是在我家附近，很不错的地方"
    And I press "发表"

    When I go to the groups page
    And I follow "西瓜守望者"
    Then I should see "饭桌最近话题"
    And I should see "我发现了一个很好的卖西瓜的地方"

    When I log out
    And I log in as "Kate Tester"
    And I go to the groups page
    And I follow "西瓜守望者"
    And I follow "我发现了一个很好的卖西瓜的地方"
    When I fill in "content" with "恩，不错。" within ".new_comment"
    And I press "+评论"
    Then I should see "恩，不错。"
    And I go to the groups page
    And I follow "西瓜守望者"
    Then I should see "1" within "#group_posts"


  Scenario: User will be suggested to select some groups
    When I log in as "David User"
    And I go to David's profile editing page
    And I should see "海鲜爱好者"


