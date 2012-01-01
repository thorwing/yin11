#encoding utf-8
Feature: create comment
  注册用户，编辑，管理员额可以对文章添加评论
  访客不可以对文章添加评论
  用户会得到还可以输入多少字的提示
  评论可以是嵌套的
  用户不可以太频繁地添加评论

#
#  Background:
#    Given There are minimum seeds data
#    And There are some reviews
#    And There are some products
#
#  Scenario Outline: 访客不可以对文章添加评论
#      When I go to the <index> page
#      And I follow "<item>"
#      Then I should not see "div" whose id is "new_comment"
#
#      Examples:
#      | index    | item             |
#      | articles | 三聚氰胺再现上海 |
#
#
#
#  @javascript
#  Scenario: 用户会得到还可以输入多少字的提示
#    When I log in as "David User"
#    And I go to the articles page
#    When I follow "三聚氰胺再现上海"
#    When I fill in "content" with "很不错"
#    Then I should see "您还可输入497字"
#
#
#  Scenario: 评论可以是嵌套的
#    When I log in as "David User"
#    When I go to the articles page
#    When I follow "三聚氰胺再现上海"
#    When I fill in "content" with "我是第一个评论的人"
#    And I press "+评论"
#    And I log out
#
#    When I log in as "Kate Tester"
#    When I go to the articles page
#    When I follow "三聚氰胺再现上海"
#    Then I should see "回复" within ".comment"
#    And I follow "回复"
#    And I fill in "content" with "评论嵌套" within ".new_comment"
#    And I press "+评论" within ".new_comment"
#    Then I should see "评论嵌套" within "#comments"
