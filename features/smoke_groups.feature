Feature: smoke tests for Groups

  Background:
    Given There are minimal testing records

  @focus
  Scenario: Guest can visit a group
    When I go to the groups page
    And I should see "所有饭桌"
    #And I should see "搜索"

  @focus
  Scenario: Only user can create a group
    When I go to the new_group page
    Then I should be on the log_in page

    When I log in as "David User"
    And I go to the new_group page
    Then I should be on the new_group page
    And I should see "新建饭桌"
    When I fill in "group_name" with "大华小龙虾搜查队"
    #And I fill in "group_location" with "大华地区"
    And I fill in "group_tags_string" with "小龙虾"
    And I press "完成"
    When I go to the groups page
    Then I should see "大华小龙虾搜查队"
    Then I should see "1成员"

  @focus
  Scenario: User can join a group
    Given the following group exists:
    | name       | tags_string |
    | 西瓜守望者 | 西瓜        |

    When I log in as "David User"
    And I join the group "西瓜守望者"
    And I go to the profile page
    Then I should see "西瓜守望者"

  @focus
  Scenario: User can quit a group
    Given the following group exists:
    | name       | tags_string |
    | 西瓜守望者 | 西瓜        |

    When I log in as "David User"
    And I join the group "西瓜守望者"
    And I go to the profile page
    And I follow "西瓜守望者"
    And I follow "退出"
    And I go to the profile page
    Then I should not see "西瓜守望者"

  @focus
  Scenario: post from another group member will get marked for me
    Given the following group exists:
      | name       | tags_string |
      | 西瓜守望者 | 西瓜        |

    # generate some stuff, try to fill the home page
    Given There are some sample articles
    And There are some sample tips

    When I log in as "David User"
    And I join the group "西瓜守望者"
    And I post a simple review without vendor

    When I log out
    And I log in as "Kate Tester"
    Then I should not see "相关饭桌：西瓜守望者"
    When I join the group "西瓜守望者"
    And I go to the home page
   Then I should see "相关饭桌：西瓜守望者"

  @focus
  Scenario: User can block and unlock another group member
    Given the following group exists:
      | name       | tags_string |
      | 西瓜守望者 | 西瓜        |

    When I log in as "David User"
    When I join the group "西瓜守望者"
    And I post a simple review without vendor

    When I log out
    And I log in as "Kate Tester"
    And I join the group "西瓜守望者"
    When I go to the home page
    Then I should see "买到烂西瓜"
    And I go to the profile page
    And I follow "西瓜守望者"
    And I follow "阻止"
    And I go to the home page
    Then I should not see "买到烂西瓜"

     And I go to the profile page
    And I follow "西瓜守望者"
    And I follow "解除阻止"
    And I go to the home page
    Then I should see "买到烂西瓜"

  @focus
  Scenario: Group member can post for his group
    Given the following group exists:
      | name       | tags_string |
      | 西瓜守望者 | 西瓜        |

    When I log in as "David User"
    And I join the group "西瓜守望者"
    And I go to the groups page
    And I follow "西瓜守望者"
    When I follow "+新话题"
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
    When I fill in "content" with "恩，不错。"
    And I press "添加评论"
    Then I should see "恩，不错。"
    And I go to the groups page
    And I follow "西瓜守望者"
    Then I should see "1" within "#group_posts"

