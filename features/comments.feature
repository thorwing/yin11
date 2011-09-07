#encoding utf-8

Feature: Comments

  Background:
    Given There are minimum seeds data

  Scenario: Guest can not comment
    Given There are some sample articles
    When I go to the home page
    Then I should see "三聚氰胺再现上海"
    When I follow "三聚氰胺再现上海"
    Then I should not see "发表"

  @focus
  @javascript
  Scenario:  User can comment on a review, comments can be nested.
    Given the following review exists:
    | title      | tags_string  | content |
    | 买到烂西瓜 | 西瓜         | 西瓜切开来后发现已经熟过头了。 |

    When I log in as "Kate Tester"
    When I follow "买到烂西瓜"
    And I fill in "content" with "很有用的评价" within ".new_comment"
    And I press "+评论"
    Then I should see "很有用的评价" within "#comments"
    And I go to the home page
    And I follow "买到烂西瓜"
    Then I should see "很有用的评价"

    When I log in as "David User"
    When I follow "买到烂西瓜"
    And I fill in "content" with "谢谢" within ".new_comment"
    And I press "+评论"
    And I go to the home page
    And I follow "买到烂西瓜"
    Then I should see "很有用的评价"
    Then I should see "谢谢"

  @javascript
  Scenario: Users can comment on a article
    Given the following article exists:
      | title            | content                            | tags_string |
      | 西瓜被打了催熟剂 | 本报讯，今日很多西瓜都被打了催熟剂 | 西瓜      |

    When I log in as "David User"
    When I follow "西瓜被打了催熟剂"
    And I fill in "content" with "很有用的评价" within ".new_comment"
    And I press "+评论"
    Then I should see "很有用的评价"

    When I log in as "Kate Tester"
    When I follow "西瓜被打了催熟剂"
    And I fill in "content" with "谢谢" within ".new_comment"
    And I press "+评论"
    Then I should see "谢谢"

  @javascript
  Scenario: User can reply others comment
    Given the following review exists:
    | title    |
    | 西瓜烂了 |
    When I log in as "David User"
    When I go to the home page
    When I follow "西瓜烂了"
    When I fill in "content" with "很不错"
    And I press "+评论"

    When I log in as "Kate Tester"
    And I follow "西瓜烂了"
    And I follow "回复"
    And I fill in "content" with "谢谢"
    And I press "+评论"
    Then I should see "谢谢"

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




