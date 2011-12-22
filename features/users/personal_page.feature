
Feature: tests user's personal page
  注册用户，编辑，管理员可以访问它的个人首页
  访客无法访问个人首页
  注册用户，编辑，管理员可以在个人首页上直接发布分享
  注册用户，编辑，管理员可以看到个人的基本信息
  注册用户，编辑，管理员可以看到各种动态（全部，个人，所关注的）
  注册用户点击昵称,可进入自己或者他人个人首页
  注册用户点击自己的粉丝数, 可以看到自己的粉丝

  Background:
    Given There are minimum seeds data

  Scenario Outline: 注册用户，编辑，管理员可以访问它的个人首页
    When I log in as "<user>"
    And I should see "我的首页"
    When I follow "我的首页"
    Then I should be on the me page

    Examples:
    | user |
    | David User |
    | Castle Editor |
    | Mighty Admin  |

  Scenario: 访客无法访问个人首页
    When I go to the home page
    Then I should not see "我的首页"
    When I go to the me page
    Then I should be on the login page

  @javascript
  Scenario Outline: 注册用户，编辑，管理员可以在个人首页上直接发布分享
    When I log in as "<user>"
    And I follow "我的首页"
    Then I fill in "review_content" with "今天吃到了好吃的"
    And I press "发表分享"
    And I follow "我的动态"
    Then I should see "今天吃到了好吃的" within ".dynamictab"

    Examples:
    | user |
    | David User |
    | Castle Editor |
    | Mighty Admin  |

  Scenario Outline: 注册用户，编辑，管理员可以看到个人的基本信息
    Given There are some products
    When I log in as "<user>"
    #later Kate will visit the user via this review
    And I post a simple review for "梅山猪" with "发现了上好的猪肉"
    And I I follow "我的首页"
    And I follow "<user_name>" within "#user_panel"
    Then I should be on <user_name>'s profile page
    And I should see "基本信息"
    And I should see "div" whose "id" is "user_panel"
    When I log out
    And I log in as "Kate Tester"
    And I go to the reviews page
    And I follow "<user_name>"
    Then I should be on <user_name>'s user page
    And I should not see "基本信息"

    Examples:
    | user |
    | David User |
    | Castle Editor |
    | Mighty Admin  |

  Scenario Outline: 注册用户，编辑，管理员可以看到各种动态（全部，个人，所关注的）
    When I log in as "<user>"
    And I follow "我的首页"
    Then I should see "div" whose "id" is "feeds"

    Examples:
    | user |
    | David User |
    | Castle Editor |
    | Mighty Admin  |