#encoding utf-8
Feature: modify a product
  管理员可以修改商品的展示名, 但不可以修改商品的原始名
  管理员可以看到未启用的商品
  访客,编辑,注册用户不可以看到未启用的商品
  管理员可以设置商品的推荐指数，该指数将影响商品在列表（主页，检索页）上的排名
  访客,编辑,注册用户不可以修改商品
  管理员可以删除商品
  访客,编辑,注册用户不可以删除商品
  管理员,访客,注册用户不可以手工录入商品

  Background:
    Given There are minimum seeds data
    And There are some products
    And There are some topics

  Scenario: 管理员可以修改商品的展示名, 但不可以修改商品的原始名
    When I log in as "Mighty Admin"
    And I view the details of product "苏北草母鸡"
    And I follow "修改"
    Then I should see "input" whose "id" is "product_name"
    And I should not see "input" whose "id" is "product_original_name"
    When I fill in "product_name" with "母鸡变鸭"
    And I press "完成"
    When I go to the products page
    Then I should see "母鸡变鸭"
    And I should not see "苏北草母鸡"

  Scenario: 管理员可以看到未启用的商品
    When I log in as "Mighty Admin"
    And I disabled a product named "苏北草母鸡"
    When I go to the products page
    Then I should not see "苏北草母鸡"
    When I go to the administrator_products page
    Then I should see "苏北草母鸡"
    When I follow "苏北草母鸡"
    And I follow "修改"
    And I check "product_enabled"
    And I press "完成"
    When I log out
    And I go to the products page
    Then I should see "苏北草母鸡"

  Scenario Outline: 访客, 编辑, 注册用户不可以看到未启用的商品
    When I log in as "Mighty Admin"
    And I disabled a product named "苏北草母鸡"
    And I log out
    When I log in as "<user>"
    And I go to the products page
    Then I should not see "苏北草母鸡"
    When I go to the administrator_products page
    Then I should not be on the administrator_products page

    Examples:
    | user |
    | Guest |
    | David User |
    | Castle Editor |

  Scenario: 管理员可以设置商品的启用属性
    When I log in as "Mighty Admin"
    And I disabled a product named "苏北草母鸡"
    When I go to the products page
    Then I should not see "苏北草母鸡"

    #TODO
#  Scenario: 管理员可以设置商品的推荐指数，该指数将影响商品在列表（主页，检索页）上的排名
#    Given There are more products
#    When I go to the home page
#    Then I should not see "山西陈醋"
#    When I log in as "Mighty Admin"
#    And I view the details of product "山西陈醋"
#    And I follow "修改"
#    And I fill in "product_editor_score" with "100"
#    And I press "完成"
#    When I log out
#    And I go to the home page
#    Then I should see "山西陈醋"

  Scenario Outline: 访客, 编辑, 注册用户不可以修改商品
     When I log in as "<user>"
    Given There are more products
    When I view the details of product "苏北草母鸡"
    And I should not see "修改"

    Examples:
    | user |
    | Guest |
    | David User |
    | Castle Editor |

  Scenario: 管理员可以删除商品
    When I log in as "Mighty Admin"
    And I view the details of product "苏北草母鸡"
    And I follow "删除"
    And I go to the products page
    Then I should not see "苏北草母鸡"

  Scenario Outline: 访客, 编辑, 注册用户不可以删除商品
    When I log in as "<user>"
    And I view the details of product "苏北草母鸡"
    And I should not see "删除"

    Examples:
    | user |
    | Guest |
    | David User |
    | Castle Editor |


  Scenario Outline: 管理员,可以手工录入商品
    Given the following vendor exists:
      | name       |
      | 崇明养殖基地 |
    When I log in as "<user>"
    And I go to the products page
    Then I should see "+产品"
    When I go to the vendors page
    And I follow "崇明养殖基地"
    Then I should see "+产品"
    And I follow "+产品"
    Then I should be on the new_product page
#    And I fill in "product_name" with "崇明猪"
#    And I fill in "product_vendor_token" with "崇明养殖基地"
#    And show me the page
#    And I press "完成"
    #    And I go to the products page
    #    Then I should see "崇明猪"

    Examples:
    | user        |
    | Castle Editor |

  Scenario Outline: 访客,注册用户不可以手工录入商品
    Given the following vendor exists:
      | name       |
      | 崇明养殖基地 |
    When I log in as "<user>"
    And I go to the products page
    Then I should not see "+产品"
    When I go to the vendors page
    And I follow "崇明养殖基地"
    Then I should not see "+产品"

    Examples:
    | user        |
    | Guest       |
    | David User  |