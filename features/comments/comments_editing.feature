#encoding utf-8
@focus
Feature: edit comments
  编辑，管理员可以控制评论的可见性
  访客，注册用户不可以控制评论的可见性

  Background:
    Given There are minimum seeds data
    And There are some sample articles
    And There are some sample reviews

  Scenario Outline: 编辑，管理员可以控制评论的可见性
    When I log in as "David User"
    And I go to the <index> page
    And I follow "<item>"
    When I fill in "content" with "TMD"
    And I press "+评论"
    Then I should see "TMD"

    When I log in as "<user>"
    And I go to the <index> page
    And I follow "<item>"
    Then I should see "TMD"
    And I follow "启用/禁用"

    When I log in as "David User"
    And I go to the <index> page
    And I follow "<item>"
    Then I should not see "TMD"
    And I should not see "启用/禁用"

    Examples:
    |user           | index    | item             |
    |David User     | articles | 三聚氰胺再现上海 |
    |Castle Editor  | reviews  | 牛奶坏了         |








