@focus
Feature: create article
  编辑和管理员可以新建文章
  主页上有新建文章的链接
  游客和用户不可以新建文章

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
