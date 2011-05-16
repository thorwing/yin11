Feature: general usage
  User can do some basic stuff

  Background:
    Given There is a "David User"
    And There is a "Castle Editor"
    And There are minimal testing records

  Scenario: Guest can visit the entry page
    Given I go to the home page
    Then I should see "买什么食物呢？"
    And I should see "可以填写多个食物，我们会为您检查是否有相克的食物"
    And I should see "快速登录"

  Scenario: Guest can search for food
    When I search for "西瓜"
    Then I should see "最近关于西瓜的食品安全新闻"
    And I should see "食物安全风向标"
    And I should see "最近对于西瓜的评论"
    And I should see "西瓜的安全食用知识"
    And I should not see "最近关于牛奶的食品安全新闻"

  Scenario: Registered user can post a examination about food and that examination will be rendered to others
    When I log in as "David User"
    And I post a sample review

    When I log out
    And I go to the home page
    And I fill in "foods" with "西瓜"
    And I press "搜索" within "#foods_search"
    Then I should see "David 报告 上海 大华二路 XX水果超市 的 西瓜 :" within "div.food_reviews"

  Scenario: Editor can post a news and that news will be rendered to others
    When I log in as "Castle Editor"
    And I go to the articles page
    And I follow "发表新文章"
    And I fill in "article_title" with "土豆刷绿漆，冒充西瓜"
    And I fill in "article_content" with "今日，A城警方在B超市，查获了一批疑似用土豆刷上油漆冒充的西瓜。"
    And I fill in "article_source" with "神农食品报"
    And I fill in "article_food_tokens" with "西瓜"
    And I fill in "article_city_tokens" with "021"
    And I fill in "article_vendor" with "B超市"
    And I press "发表"
    Then I should see "文章已发布"

    When I log out
    And I search for "西瓜"
    Then I should see "土豆刷绿漆，冒充西瓜" within "div.food_articles"

  Scenario: User can search for conflicts with two different foods
    When I search for "牛奶 橙子"
    Then I should see "牛奶 橙子 影响维生素吸收"

  Scenario Outline: User can update his profile and that's gonna affect the search
    When I log in as "David User"
    And I go to the profile page
    And I follow "修改"
    And I fill in "profile_address_city" with "<city_id>"
    And I press "完成"
    And I search for "牛奶"
    Then I should see "三聚氰胺再现上海" within "<container>"

    Examples:
      | city_id | container       |
      | 021     | #food_article_0 |
      | 010     | #food_article_1 |

  Scenario: Registered user can write a wiki page about food
    When I log in as "David User"
    And I go to the wiki page
    And I search wiki for "西瓜"
    Then I should see "找不到和查询相匹配的结果。"

    When I follow "西瓜"
    Then I should see "新页面"

    When I fill in "page_content" with "夏日圣品"
    And I select "食物" from "page_category_id"
    And I press "保存"
    Then I should see "页面已添加"















