Feature: create article
  编辑和管理员可以新建文章
  个人主页上有新建文章的链接
  游客和用户不可以新建文章
  新建文章默认的来源是美食客栈网站
  新建文章默认的启用状态是启用的
  推送文章到主页

  Background:
    Given There are minimum seeds data

  Scenario Outline: 编辑和管理员可以新建文章
    When I log in as "<user>"
    And I post an article with:
    | title | content | tags |
    | 土豆刷绿漆，冒充西瓜  | 今日，A城警方在B超市，查获了一批疑似用土豆刷上油漆冒充的西瓜。 | 西瓜 |
    When I go to the articles page
    Then I should see "土豆刷绿漆，冒充西瓜"

  Examples:
      | user        |
      | Castle Editor |
      | Mighty Admin  |

  Scenario Outline:   个人主页上有新建文章的链接
    When I log in as "<user>"
    And I go to the me page
    Then I should see "+文章"
    When I follow "+文章"
    Then I should be on the new_article page

  Examples:
      | user        |
      | Castle Editor |
      | Mighty Admin  |

  Scenario Outline: 游客和用户不可以新建文章
    When I log in as "<user>"
    And I go to the me page
    Then I should not see "+文章"
    When I go to the new_article page
    Then I should not be on the new_article page

  Examples:
      | user         |
      | Guest       |
      | David User  |

  Scenario: 新建文章默认的来源是美食客栈网站
    When I log in as "Castle Editor"
    And I go to the me page
    And I follow "+文章"
    Then the "article_source_attributes_name" field should contain "美食客栈原创"


  Scenario: 新建文章默认的启用状态是启用的
    When I log in as "Castle Editor"
    And I post an article with:
    | title | content | tags | type |
    | 土豆冒充西瓜  | 土豆刷绿漆，冒充西瓜 | tag | theme |

    When I log out
    And I go to the articles page
    Then I should see "土豆冒充西瓜" within "#news_list"

   Scenario: 推送文章到主页
    When I log in as "Castle Editor"
    And I post an article with:
    | title | content | tags | type |
    | 土豆冒充西瓜  | 土豆刷绿漆，冒充西瓜 | tag | theme |
    And I go to the articles page
    Then I should see "土豆冒充西瓜" within "#news_list"
    And I should not see "土豆冒充西瓜" within "#news_block"
    And I recommand an article named "土豆冒充西瓜"
    When I log out
    And I go to the articles page
    Then I should see "土豆冒充西瓜" within "#news_block"
