Feature: general usage
  User can do some basic stuff

  Background:
    Given There are minimal testing records

  Scenario: Guest can visit the entry page
    When I go to the home page
    Then I should see "您的餐桌安全吗？"
    And I should see "快速登录"

  Scenario: Guest can search for food
    When I search for "西瓜"
    Then I should see "安全评估为"
    And I should see "警惕以下关于“西瓜”的负面信息"
    And I should see "请阅读以下关于“西瓜”的参考"

  @focus
  Scenario: User can see the control panel on home page
    When I log in as "David User"
    Then I should see "div" whose id is "control_panel"
    And I should see "锦囊" within "#control_panel .tab"
    And I should see "食物" within "#control_panel .tab"
    And I should see "饭桌" within "#control_panel .tab"

  Scenario: Normal user can post reviews
    When I go to the new_review page
    Then I should be on the log_in page

    When I log in as "David User"
    Then I should be on the new_review page

    When I post a simple review without vendor
    And I log out
    And I search for "西瓜"
    Then I should see "买到烂西瓜" within "#bad_items"

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
     And I fill in "added_foods" with "西瓜,牛奶" within "#control_panel"
     And I press "添加" within "#control_panel"
     Then I should see "西瓜" within "#control_panel"
     And I should see "牛奶" within "#control_panel"
     And I should see "注意" within "#control_panel"

  Scenario: I should see tags cloud on home page
     And I go to the home page
     Then I should not see "西瓜" within "#tag_cloud"

     When I log in as "David User"
     When I post a simple review without vendor
     And I go to the home page
     Then I should see "西瓜" within "#tag_cloud"

  Scenario: Editor can post an article and that article will be rendered to others
    When I log in as "Castle Editor"
    And I go to the admin_articles page
    And I follow "发表新文章"
    And I fill in "article_title" with "土豆刷绿漆，冒充西瓜"
    And I fill in "article_content" with "今日，A城警方在B超市，查获了一批疑似用土豆刷上油漆冒充的西瓜。"
    And I fill in "article_source_attributes_name" with "神农食品报"
    And I fill in "article_tags_string" with "西瓜"
    And I fill in "article_region_tokens" with "021"
    And I press "完成"

    When I log out
    And I search for "西瓜"
    Then I should see "土豆刷绿漆，冒充西瓜" within "#bad_items"


  Scenario: User will get rewards because of posting reviews.
    Given the following badge exists:
    | name     | description  | contribution_field | comparator | compared_value |
    | 新手上路 | 发表一篇测评 | created_reviews    | 8          | 1              |
    When I log in as "David User"
    And I post a simple review without vendor

    When I go to the home page
    And I follow "徽章" within "#top_menu"
    Then I should see "×1"

  Scenario Outline: Editor and Admin can go to the admin_control page
    When I log in as "<user>"
    And I go to the admin_root page
    Then I should be on the admin_root page

    Examples:
    | user          |
    | Castle Editor |
    | Ray Admin     |












