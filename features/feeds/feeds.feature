@focus
Feature: tests for Feeds
  用户可以在“我的首页”看到动态信息

  注册用户可以关注一个商品，并得到相关的动态; 取消关注则不再接收相关的动态

  注册用户可以关注一个商家，并得到相关的动态; 取消关注则不再接收相关的动态

  注册用户可以关注一个用户，并得到相关的动态; 取消关注则不再接收相关的动态

  注册用户可以关注一个饭桌，并得到相关的动态; 取消关注则不再接收相关的动态

  访客不可以关注一个商品, 商家, 用户, 饭桌, 标签

  Background:
    Given There are minimum seeds data

  Scenario: 用户可以在“我的首页”看到动态信息
    When I log in as "David User"
    And I go to the me page
    Then I should see "div" whose "id" is "feeds"
    And I should see "用户动态"

  @javascript
  Scenario Outline: 注册用户可以关注一个商品，并得到相关的动态; 取消关注则不再接收相关的动态
    Given There are some products
    When I log in as "Kate Tester"
    And I post a simple review for "苏北草母鸡" with "非常滋补"
    And I log out

    When I log in as "<user>"
    And I go to the me page
    Then I should not see "非常滋补"

    When I follow "苏北草母鸡" of kind "products"
    Then I should see "+关注"
    When I follow "+关注"
    Then I should see "-取消关注"

    When I go to the me page
    Then I should see "非常滋补"

    When I follow "苏北草母鸡" of kind "products"
    And I follow "-取消关注"

    When I go to the me page
    Then I should not see "非常滋补"

    Examples:
    | user |
    | David User |
    | Castle Editor |
    | Mighty Admin  |


  @javascript
  Scenario Outline: 注册用户可以关注一个商家，并得到相关的动态; 取消关注则不再接收相关的动态
    Given There are some products
    When I log in as "Kate Tester"
    And I post a simple review for "苏北草母鸡" with "非常滋补"
    And I log out

    When I log in as "<user>"
    And I go to the me page
    Then I should not see "非常滋补"

    When I follow "天下养鸡网" of kind "vendors"
    Then I should see "+关注"
    When I follow "+关注"
    Then I should see "-取消关注"

    When I go to the me page
    Then I should see "非常滋补"

    When I follow "天下养鸡网" of kind "vendors"
    And I follow "-取消关注"

    When I go to the me page
    Then I should not see "非常滋补"

    Examples:
    | user |
    | David User |
    | Castle Editor |
    | Mighty Admin  |

  @javascript
  Scenario Outline: 注册用户可以关注一个用户，并得到相关的动态; 取消关注则不再接收相关的动态
    Given There are some products
    When I log in as "Kate Tester"
    And I post a simple review for "苏北草母鸡" with "非常滋补"
    And I log out

    When I log in as "<user>"
    And I go to the me page
    Then I should not see "非常滋补"

    When I follow "Kate" of kind "users"
    Then I should see "+关注"
    When I follow "+关注"
    Then I should see "-取消关注"

    When I go to the me page
    Then I should see "非常滋补"

    When I follow "Kate" of kind "users"
    And I follow "-取消关注"

    When I go to the me page
    Then I should not see "非常滋补"

    Examples:
    | user |
    | David User |
    | Castle Editor |
    | Mighty Admin  |

  @javascript
  Scenario Outline: 注册用户可以关注一个饭桌，并得到相关的动态; 取消关注则不再接收相关的动态
    Given There are some products
    And There are some groups

    When I log in as "Kate Tester"
    And I join the group "肉食爱好者"
    And I post a simple review for "梅山猪" with "发现了上好的猪肉"
    And I log out

    When I log in as "<user>"
    And I go to the me page
    Then I should not see "发现了上好的猪肉"

    When I join the group "肉食爱好者"
    And I go to the me page
    Then I should see "发现了上好的猪肉"

    When I follow "肉食爱好者" of kind "groups"
    And I follow "离席"
    And I go to the me page
    Then I should not see "发现了上好的猪肉"

    Examples:
    | user |
    | David User |
    | Castle Editor |
    | Mighty Admin  |

  Scenario Outline: 访客不可以关注一个商品, 商家, 用户, 饭桌
    Given There are some products
    And There are some groups
    When I follow "<subject>" of kind "<path>"
    Given There are some products
    Then I should not see "+关注"

    Examples:
    | subject | path |
    | 梅山猪     | products |
    | 天下养鸡网 | vendors |
    | Kate   | users |
    | 肉食爱好者 | groups |