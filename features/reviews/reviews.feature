Feature: tests for reviews
  访客不能添加分享
  注册用户，编辑，管理员可以添加分享
  注册用户，编辑，管理员可以发表待图片的分享
  注册用户，编辑，管理员可以为分享打分
  用户可以删除分享

  用户可以访问“厨房达人秀”页面
  在达人秀页面，用户可以看到热门的分享（热门分享一定是能够显示图片的：用户上传，或和商品关联）
  用户可以通过分享查看其发表用户的信息
  注册用户可以在专题页面添加分享，分享便会被归类到该专题下

  Background:
    Given There are minimum seeds data
    And There are some products

  Scenario Outline: 注册用户，编辑，管理员可以添加分享
    When I log in as "<user>"
    And I view the details of product "苏北草母鸡"
    And I should see "input" whose id is "review_content"

    When I fill in "review_content" with "用来炖鸡汤不错"
    And I press "发表分享"
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
    And I should not see "发表分享"

  Scenario Outline: 注册用户，编辑，管理员可以发表待图片的分享
    When I log in as "<user>"
    And I view the details of product "苏北草母鸡"
    Then I should see "object" whose id is "image_uploaderUploader"

  Examples:
    | user |
    | David User |
    | Castle Editor|
    | Mighty Admin |

  @javascript
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

  Scenario: 用户可以删除分享

  Scenario: 用户可以访问“厨房达人秀”页面
    Given There are some products
    When I go to the home page
    Then I should see "厨房达人秀" within "#top_menu"
    When I follow "厨房达人秀" within "#top_menu"
    Then I should be on the reviews page

  Scenario: 在达人秀页面，用户可以看到热门的分享（热门分享一定是能够显示图片的：用户上传，或和商品关联）
    When I log in as "David User"
    And I post a simple review for "梅山猪" with "非常香的猪肉"
    And I go to the reviews page
    And I should see "非常香的猪肉"

  Scenario: 用户可以通过分享查看其发表用户的信息
    When I log in as "David User"
    And I post a simple review for "梅山猪" with "非常香的猪肉"
    And I log out

    When I log in as "Kate Tester"
    And I go to the reviews page
    Then I should see "非常香的猪肉"
    When I follow "David"
    Then I should be on David's user page

  Scenario: 注册用户可以在专题页面添加分享，分享便会被归类到该专题下
    Given There are some topics
    When I log in as "David User"
    And I follow "冬令进补" of kind "topics"
    And I fill in "review_content" with "梅山猪肉非常香"
    And I press "发表分享"
    And I follow "冬令进补" of kind "topics"
    Then I should see "梅山猪肉非常香"

