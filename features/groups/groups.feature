Feature: tests for groups
  所有人都可以查看一个饭桌
  只有管理员才可以创建饭桌
  除管理员外都不可以创建饭桌
  注册用户可以加入，推出一个饭桌
  访客不可以加入饭桌
  饭桌成员可以在饭桌内发表一个话题
  访客不可以发表话题
  注册用户会被建议加入一些饭桌

  Background:
    Given There are minimum seeds data
    And There are some groups

  Scenario Outline: 所有人都可以查看一个饭桌
    When I log in as "<user>"
    And I follow "西瓜守望者" of kind "groups"
    Then I should see "西瓜守望者"

    Examples:
    | user |
    | Guest |
    | David User |
    | Castle Editor |

  Scenario: 只有管理员才可以创建饭桌
    When I log in as "Mighty Admin"
    And I go to the new_group page
    Then I should be on the new_group page
    When I fill in "group_name" with "小龙虾搜查队"
#    And I fill in "group_tags_string" with "小龙虾"
    And I press "完成"
    When I go to the groups page
    Then I should see "小龙虾搜查队"

  Scenario Outline: 除管理员外都不可以创建饭桌
    When I log in as "<user>"
    When I go to the new_group page
    Then I should not be on the new_group page

    Examples:
    | user |
    | Guest |
    | David User |
    | Castle Editor |

  @javascript
  Scenario Outline: 注册用户可以加入，推出一个饭桌
    When I log in as "<user>"
    And I join the group "西瓜守望者"
    Then I should see "离席"
    And Confirm that "David" is in the group "西瓜守望者"

    When I follow "西瓜守望者" of kind "groups"
    And I follow "离席"
    Then Confirm that "David" is not in the group "西瓜守望者"

    Examples:
    | user |
    | David User |
    | Castle Editor |
    | Mighty Admin  |

  Scenario: 访客不可以加入饭桌
    When I follow "西瓜守望者" of kind "groups"
    Then I should not see "加入"

  Scenario Outline: 饭桌成员可以在饭桌内发表一个话题
    When I log in as "<user>"
    And I join the group "西瓜守望者"
    And I follow "西瓜守望者" of kind "groups"
    When I follow "+话题"
    And I fill in "post_title" with "我发现了一个很好的卖西瓜的地方"
    And I fill in "post_content" with "这个地方是在我家附近，很不错的地方"
    And I press "发表"

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

    Examples:
    | user |
    | David User |
    | Castle Editor |
    | Mighty Admin  |

  Scenario: 访客不可以发表话题
    When I follow "西瓜守望者" of kind "groups"
    Then I should not see "+话题"

  Scenario: 注册用户会被建议加入一些饭桌
    When I log in as "David User"
    And I go to David's profile editing page
    And I should see "海鲜爱好者"


