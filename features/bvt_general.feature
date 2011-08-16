Feature: general usage
  User can do some basic stuff

  Background:
    Given There are minimum seeds data

  Scenario: Guest can Admin can change other user's rolevisit the entry page
    When I go to the home page
    Then I should see "您的餐桌安全吗？"
    And I should see "登入"

  Scenario: User can see the control panel on home page
    When I log in as "David User"
    Then I should see "div" whose id is "control_panel"
    And I should see "关注的标签" within "#control_panel"
    And I should see "关注的地点" within "#control_panel"
    And I should see "收藏的锦囊" within "#control_panel"
    And I should see "加入的饭桌" within "#control_panel"


  Scenario: Normal user can post reviews
    When I go to the new_review page
    Then I should be on the login page

    When I log in as "David User"
    Then I should be on the new_review page

    When I post a simple review without vendor

    And I log out
    And I query for "西瓜"
    Then I should see "买到烂西瓜" within "#items_list"

#  Scenario: Only authorized user can post reviews
#    When I log in as "David User"
#    And I go to the new_review page
#    Then I should be on the home page
#
#    When I log in as "Kate Tester"
#    Then I should see "新测评"
#    Then I post a simple review without vendor
#
#    When I log out
#    And I go to the home page
#    And I fill in "search" with "西瓜"
#    And I press "搜索" within "#search_frame"
#    Then I should see "买到烂西瓜" within "#bad_items"

  Scenario: I should see my collection on home page
     When I log in as "David User"
     And I post a simple review without vendor
     And I go to the home page
     And I add "西瓜,牛奶" to watching foods list
     Then I should see "西瓜" within "#control_panel"
     And I should see "牛奶" within "#control_panel"
     And I should see "1" within "#control_panel"

  Scenario: I should see tags cloud on home page
     And I go to the home page
     Then I should not see "西瓜" within "#tag_cloud"

     When I log in as "David User"
     When I post a simple review without vendor
     And I go to the home page
     Then I should see "西瓜" within "#tag_cloud"

  Scenario: Editor can post an article and that article will be rendered to others
    When I log in as "Castle Editor"
    And I post a simple article

    When I log out
    And I go to the home page
    Then I should see "土豆刷绿漆，冒充西瓜"

  Scenario: User will get rewards because of posting reviews.
    Given the following badge exists:
    | name     | description  | contribution_field | comparator | compared_value |
    | 新手上路 | 发表一篇测评 | posted_reviews    | >=         | 1              |
    When I log in as "David User"
    And I post a simple review without vendor

    When I go to the home page
    And I follow "徽章" within "#top_menu"
    Then I should see "(1)"

  Scenario Outline: Editor and Admin can go to the admin_control page
    When I log in as "<user>"
    And I go to the admin_root page
    Then I should be on the admin_root page

    Examples:
    | user          |
    | Castle Editor |
    | Ray Admin     |












