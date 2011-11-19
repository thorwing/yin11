Feature: tests user's personal page
  注册用户，编辑，管理员可以访问它的个人首页
  访客无法访问个人首页
  注册用户，编辑，管理员可以在个人首页上直接发布分享
  注册用户，编辑，管理员可以看到个人的基本信息
  注册用户，编辑，管理员可以看到各种动态（全部，个人，所关注的）

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
    And I press "发表测评"
    Then I should see "今天吃到了好吃的" within "#feeds"

    Examples:
    | user |
    | David User |
    | Castle Editor |
    | Mighty Admin  |

  Scenario Outline: 注册用户，编辑，管理员可以看到个人的基本信息
    When I log in as "<user>"
    And I follow "我的首页"
    Then I should see "div" whose "id" is "user_panel"

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