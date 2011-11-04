#encoding utf-8

Feature: modify article
  编辑和管理员可以修改文章
  访客和用户不可以修改文章
  编辑和管理员可以撰写一个专题，并将之推选到主页上
  管理员 编辑可以启用/禁用 article

  Background:
    Given There are minimum seeds data

  Scenario Outline: 编辑和管理员可以修改文章
    Given There are some sample articles
    When I log in as "<user>"
    And I view an article named "三聚氰胺再现上海"
    And I follow "编辑"
    And I fill in "article_title" with "三聚氰胺问题很严重"
    And I press "完成"
    When I go to the articles page
    Then I should not see "三聚氰胺再现上海"
    And I should see "三聚氰胺问题很严重"

    Examples:
      | user |
      | Castle Editor |
      | Mighty Admin  |

  Scenario Outline: 访客和用户不可以修改文章
    Given There are some sample articles
    When I log in as "<user>"
    And I view an article named "三聚氰胺再现上海"
    Then I should not see "编辑"

    Examples:
      | user |
      | Guest |
      | David User |

  Scenario Outline: 编辑和管理员可以撰写一个专题，并将之推选到主页上
    When I log in as "<user>"
    And I follow "+文章"
    And I fill in "article_title" with "食物相克不科学"
    And I fill in "article_content" with "这是不科学的说法"
    And I select "专题" from "article_type"
    And I check "article_recommended"
    And I press "完成"
    When I go to the home page
    Then I should see "食物相克不科学"

    Examples:
    | user |
    | Castle Editor |
    | Mighty Admin  |

  Scenario Outline: 管理员 编辑可以启用/禁用 article的enable 属性
    Given There are some sample articles
    When I log in as "<user>"
    Then I disabled a article named "三聚氰胺再现上海"
    And I go to the articles page
    Then I should not see "三聚氰胺再现上海"

    Examples:
    | user |
    | Castle Editor |
    | Mighty Admin  |