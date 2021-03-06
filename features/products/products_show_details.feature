#encoding utf-8
Feature: show details of a product
  显示商品的商户的信息
  显示其它用户的分享
  注册用户，编辑，管理员可以在商品详细信息页中对商品打分（赞，贬）
  访客不可以在商品详细信息页中对商品打分
  注册用户，编辑，管理员可以对其它用户的体验打分（赞，贬），打分结果将影响体验的排名
  访客不可以对其它用户的体验打分
  注册用户，编辑，管理员可以关注商品
  访客不可以关注商品
  注册用户，编辑，管理员可以在商品详细页上关注一个商户
  访客不可以在商品详细页上关注一个商户

  Background:
    Given There are minimum seeds data
    And There are some products

  Scenario: 显示商品的商户的信息
    When I view the details of product "苏北草母鸡"
    And I follow "天下养鸡网"
    Then I should not see "+关注"

  Scenario: 显示其它用户的分享
    When I log in as "David User"
    And I post a simple review for "苏北草母鸡" with "鸡汤不如鸡肉"
    And I log out
    When I view the details of product "苏北草母鸡"
    Then I should see "鸡汤不如鸡肉"

#  Scenario: 分享经过排序，过滤
#    When I log in as "Kate Tester"
#    And I post a simple review for "苏北草母鸡" with "鸡汤不如鸡肉"
#    And I log out
#
#    When I log in as "David User"
#    And I view the details of product "苏北草母鸡"
#    When I follow "只看我关注的人"
#    Then I should not see "鸡汤不如鸡肉"
#
#    Given "David User" follows "Kate Tester"
#    When I log in as "David User"
#    And I view the details of product "苏北草母鸡"
#    When I follow "只看我关注的人"
#    Then I should see "鸡汤不如鸡肉"

  @javascript
  Scenario Outline: 注册用户，编辑，管理员可以在商品详细信息页中对商品打分（赞，贬）
    When I log in as "<user>"
    And I view the details of product "苏北草母鸡"
    Then I should see "div" whose "class" is "vote_fields"
    When I follow "up" within ".vote_fields"
    Then I should see "<voting_weight>"

    Examples:
    | user | voting_weight |
    | David User | 1    |
    | Castle Editor | 3 |
    | Mighty Admin  | 5 |

  Scenario: 访客不可以在商品详细信息页中对商品打分
    And I view the details of product "苏北草母鸡"
    Then I should not see "div" whose "class" is "vote_fields"

  @javascript
  Scenario Outline: 注册用户可以对其它用户的体验打分（赞，贬），打分结果将影响体验的排名
    When I log in as "Kate Tester"
    And I post a simple review for "苏北草母鸡" with "用来炖鸡汤不错"

    When I log in as "<user>"
    And I view the details of product "苏北草母鸡"
    And I follow "up" within "#reviews .vote_fields"
    Then I should see "<voting_weight>" within "#reviews .vote_fields"

    Examples:
    | user | voting_weight |
    | David User | 1    |
    | Castle Editor | 3 |
    | Mighty Admin  | 5 |

  Scenario: 访客不可以对其它用户的体验打分
    When I log in as "Kate Tester"
    And I post a simple review for "苏北草母鸡" with "用来炖鸡汤不错"

    When I log out
    And I view the details of product "苏北草母鸡"
    Then I should not see "up" within "#reviews .vote_fields"

  @javascript
  Scenario Outline: 注册用户可以关注商品
    When I log in as "<user_full_name>"
    And I view the details of product "苏北草母鸡"
    And I follow "+关注"
    And I go to <user_short_name>'s profile page
    And I follow "关注商品"
    Then I should see "苏北草母鸡"

    Examples:
    | user_full_name | user_short_name |
    | David User    | David         |
    | Castle Editor | Castle        |
    | Mighty Admin     | Ray           |

  Scenario: 访客不可以关注商品
    When I view the details of product "苏北草母鸡"
    Then I should not see "+关注"

  Scenario Outline: 注册用户可以在商品详细页上关注一个商户
    When I log in as "<user_full_name>"
    And I view the details of product "苏北草母鸡"
    And I follow "天下养鸡网"
    And I follow "+关注"
    And I go to <user_short_name>'s profile page
    Then I should see "天下养鸡网"

    Examples:
    | user_full_name | user_short_name |
    | David User    | David         |
    | Castle Editor | Castle        |
    | Mighty Admin     | Ray           |

  Scenario: 访客不可以在商品详细页上关注一个商户
    When I view the details of product "苏北草母鸡"
    And I follow "天下养鸡网"
    Then I should not see "+关注"