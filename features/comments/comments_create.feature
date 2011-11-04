#encoding utf-8
@focus
Feature: create comment
  注册用户，编辑，管理员额可以对文章，测评，产品添加评论
  访客不可以对文章，测评，产品添加评论
  用户会得到还可以输入多少字的提示
  评论可以是嵌套的
  用户不可以太频繁地添加评论

  Background:
    Given There are minimum seeds data
    And There are some sample articles
    And There are some sample reviews

  Scenario Outline: 注册用户，编辑，管理员额可以对文章，测评，产品添加评论
    When I log in as "<user>"
    And I go to the <index> page
    And I follow "<item>"
    Then I should see "div" whose id is "new_comment"

    And I fill in "content" with "很有用的评价" within ".new_comment"
    And I press "+评论"
    Then I should see "很有用的评价" within "#comments"
    And I go to the <index> page
    And I follow "<item>"
    Then I should see "很有用的评价"

    When I log in as "Kate Tester"
    And I go to the <index> page
    And I follow "<item>"
    And I fill in "content" with "谢谢" within ".new_comment"
    And I press "+评论"
    And I go to the <index> page
    And I follow "<item>"
    Then I should see "很有用的评价"
    Then I should see "谢谢"

    Examples:
    |user           | index    | item             |
    |David User     | articles | 三聚氰胺再现上海 |
    |Castle Editor  | reviews  | 牛奶坏了         |


  Scenario Outline: 访客不可以对文章，测评，产品添加评论
      When I go to the <index> page
      And I follow "<item>"
      Then I should not see "div" whose id is "new_comment"

      Examples:
      | index    | item             |
      | articles | 三聚氰胺再现上海 |
      | reviews  | 牛奶坏了         |
      | products | 苏北草母鸡        |

  @javascript
  Scenario: 用户会得到还可以输入多少字的提示
    Given the following review exists:
    | title    |
    | 西瓜烂了 |
    When I log in as "David User"
    When I go to the reviews page
    When I follow "西瓜烂了"
    When I fill in "content" with "很不错"
    Then I should see "还可以输入XX"

  Scenario: 评论可以是嵌套的

#  #TODO
#  @pending
#  @javascript
#  Scenario: 用户不可以太频繁地添加评论
#    Given the following article exists:
#      | title            | content                            | tags_string |
#      | 西瓜被打了催熟剂 | 本报讯，今日很多西瓜都被打了催熟剂 | 西瓜      |
#
#    When I log in as "David User"
#    Then I should see "西瓜被打了催熟剂"
#    When I follow "西瓜被打了催熟剂"
#    And I fill in "content" with "很有用的评价" within ".new_comment"
#    And I press "+评论"
#    And I go to the home page
#    Then I should see "+评论(1)"
#
#    When I log in as "David User"
#    When I follow "西瓜被打了催熟剂"
#    And I fill in "content" with "谢谢" within ".new_comment"
#    And I press "+评论"
#    And I go to the home page
#    Then I should not see "+评论(2)"
