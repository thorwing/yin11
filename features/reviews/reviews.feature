Feature: tests for reviews
  访客不能添加分享
  注册用户，编辑，管理员可以添加分享
  注册用户，编辑，管理员可以发表待图片的分享
  注册用户，编辑，管理员可以为分享打分
  注册用户，编辑，管理员可以为产品评出“值”与“不值”
  用户可以在“值”与“不值”两种观点间切换

  Background:
    Given There are minimum seeds data
    And There are some products

  @javascript
  Scenario Outline: 注册用户，编辑，管理员可以添加分享
    When I log in as "<user>"
    And I view the details of product "苏北草母鸡"
    And I should see "input" whose id is "review_content"

    When I fill in "review_content" with "用来炖鸡汤不错"
    And I press "发表测评"
    Then I should see "用来炖鸡汤不错"
    And I should not see "input" whose id is "review_content"

    When I view the details of product "苏北草母鸡"
    Then I should see "用来炖鸡汤不错"

  Examples:
    | user |
    | David User |
    | Castle Editor|
    | Mighty Admin |

  Scenario: 访客不能添加分享
    When I view the details of product "苏北草母鸡"
    And I should not see "input" whose id is "review_content"
    And I should not see "发表测评"

  Scenario Outline: 注册用户，编辑，管理员可以发表待图片的分享
    When I log in as "<user>"
    And I view the details of product "苏北草母鸡"
    Then I should see "object" whose id is "image_uploaderUploader"

  Examples:
    | user |
    | David User |
    | Castle Editor|
    | Mighty Admin |

  Scenario Outline: 注册用户，编辑，管理员可以为分享打分
    When I log in as "<user>"
    And I post a simple review for "苏北草母鸡" with "用来炖鸡汤不错"

    When I log out
    And I log in as "Kate Tester"
    And I view the details of product "苏北草母鸡"
    Then I should see "用来炖鸡汤不错"
    When I follow "up" within ".vote_fields"
    Then I should see "<voting_weight>" within ".vote_fields"

  Examples:
    | user | voting_weight |
    | David User | 1     |
    | Castle Editor| 3   |
    | Mighty Admin | 5   |

#  Scenario: 用户可以为产品评出“值”与“不值”
#    When I log in as "David User"
#    And I view the details of product "苏北草母鸡"
#    Then I should see "radio" whose id is "worthy"
#    And I should see "radio" whose id is "unworthy"
#    When I fill in "review_title" with "用来炖鸡汤不错"
#    And I press "发表测评"
#    Then I should see "用来炖鸡汤不错"
#    And I should see "值" within "review"
#    And I should not see "不值" within "review"
#
#  Scenario: 用户可以在“值”与“不值”两种观点间切换
#    When I log in as "David User"
#    And I view the details of product "梅山猪"
#    Then I should see "肉质鲜美，值了"
#    And I should see "太贵了，性价比不高"
#    When I follow "值"
#    Then I should see "肉质鲜美，值了"
#    And I should not see "太贵了，性价比不高"
#    When I follow "不值"
#    Then I should not see "肉质鲜美，值了"
#    And I should see "太贵了，性价比不高"

