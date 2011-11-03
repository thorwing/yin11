Feature: show details of a product
  显示商品的商户的信息
  显示其它用户的分享
  分享经过排序，过滤

  注册用户可以在商品详细信息页中对商品打分（赞，贬）
  访客不可以在商品详细信息页中对商品打分
  注册用户可以对其它用户的体验打分（赞，贬），打分结果将影响体验的排名
  访客不可以对其它用户的体验打分
  注册用户可以关注商品
  访客不可以关注商品
  注册用户可以在商品详细页上关注一个商户
  访客不可以在商品详细页上关注一个商户

  Background:
    Given There are minimum seeds data
    And There are some sample products

  Scenario: 显示商品的商户的信息
    When I view the details of product "苏北草母鸡"
    And I follow "南京养鸡场"
    Then I should not see "+关注"

  Scenario: 显示其它用户的分享
    Given the following articles exists:
      | title         | content                     | tags_string | type |
      | 鸡汤不如鸡肉   | 鸡汤的营养成分其实不如鸡肉多  | 鸡,鸡汤     | 锦囊 |
    When I log in as "David User"
    And I go to the products page
    And I follow "苏北草母鸡"
    Then I should see "鸡汤不如鸡肉"

  Scenario: 分享经过排序，过滤

  Scenario: 注册用户可以在商品详细信息页中对商品打分（赞，贬）

  Scenario Outline: 注册用户可以关注商品
    When I log in as "<user_full_name>"
    And I view the details of product "苏北草母鸡"
    And I follow "+关注"
    And I go to <user_short_name>'s profile page
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
    And I follow "南京养鸡场"
    And I follow "关注"
    And I go to <user_short_name>'s profile page
    Then I should see "南京养鸡场"

    Examples:
    | user_full_name | user_short_name |
    | David User    | David         |
    | Castle Editor | Castle        |
    | Mighty Admin     | Ray           |

  Scenario: 访客不可以在商品详细页上关注一个商户
    WhenI view the details of product "苏北草母鸡"
    And I follow "南京养鸡场"
    Then I should not see "关注"