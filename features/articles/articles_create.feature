#incoding utf-8

Feature: create article
  编辑和管理员可以新建文章
  主页上有新建文章的链接
  游客和用户不可以新建文章
  新建文章默认的启用状态是启用的
  新建文章默认的来源是银筷子网站

  Background:
    Given There are minimum seeds data

  Scenario Outline: 编辑和管理员可以新建文章
    When I log in as "<user>"
    And I post a article with:
    | title | content | tags |
    | 土豆刷绿漆，冒充西瓜  | 今日，A城警方在B超市，查获了一批疑似用土豆刷上油漆冒充的西瓜。 | 西瓜 |
    When I go to the articles page
    Then I should see "土豆刷绿漆，冒充西瓜"

  Examples:
      | user        |
      | Castle Editor |
      | Mighty Admin  |

  Scenario Outline:   主页上有新建文章的链接
    When I log in as "<user>"
    Then I should see "+文章"
    When I follow "+文章"
    Then I should be on the new_article page

  Examples:
      | user        |
      | Castle Editor |
      | Mighty Admin  |

  Scenario Outline: 游客和用户不可以新建文章
    When I log in as "<user>"
    Then I should not see "+文章"
    When I go to the new_article page
    Then I should not be on the new_article page

  Examples:
      | user        |
      | Guest       |
      | David User  |

  Scenario: 新建文章默认的来源是银筷子网站
    When I log in as "Castle Editor"
    And I follow "+文章"
    Then the "article_source_attributes_name" field should contain "银筷子原创"


  Scenario: 新建文章默认的启用状态是启用的
    When I log in as "Castle Editor"
    And I post a article with:
    | title | content | tags | type |
    | 土豆冒充西瓜  | 土豆刷绿漆，冒充西瓜 | tag | 专题 |

    When I log out
    And I go to the articles page
    Then I should see "土豆冒充西瓜"
