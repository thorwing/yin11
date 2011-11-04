#encoding utf-8
@focus
Feature: Comments
  Guest can't comment
  User can comment, and comments can be nested
  User will get hint about how many characters left
  Editor can toggle comment's availability

  Background:
    Given There are minimum seeds data
    And There are some sample articles
    And There are some sample reviews
    And There are some sample products

  Scenario Outline: Guest can't comment
    When I go to the <index> page
    And I follow "<item>"
    Then I should not see "div" whose id is "new_comment"

    Examples:
    | index    | item             |
    | articles | 三聚氰胺再现上海 |
    | reviews  | 牛奶坏了         |
    | products | 苏北草母鸡        |

  Scenario Outline: User can comment, and comments can be nested
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
    |Mighty Admin      | products | 苏北草母鸡        |


  @javascript
  Scenario: User will get hint about how many characters left
    Given the following review exists:
    | title    |
    | 西瓜烂了 |
    When I log in as "David User"
    When I go to the reviews page
    When I follow "西瓜烂了"
    When I fill in "content" with "很不错"
    Then I should see "已输入3字符"


  Scenario: Editor can toggle comment's availability
    Given the following review exists:
    | title    |
    | 西瓜烂了 |
    When I log in as "David User"
    And I go to the reviews page
    And I follow "西瓜烂了"
    When I fill in "content" with "TMD"
    And I press "+评论"
    Then I should see "TMD"

    When I log in as "Castle Editor"
    And I go to the reviews page
    And I follow "西瓜烂了"
    Then I should see "TMD"
    And I follow "启用/禁用"

    When I log in as "David User"
    And I go to the reviews page
    And I follow "西瓜烂了"
    Then I should not see "TMD"
    And I should not see "启用/禁用"



# TODO
#  @pending
#  @javascript
#  Scenario: User can't comment very often
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




