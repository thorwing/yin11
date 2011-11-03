Feature: modify a product
  管理员可以修改商品的展示名, 但不可以修改商品的原始名
  访客和用户不修改商品的展示名, 但不可以修改商品的原始名
  管理员可以修改商品的图片
  访客和用户不可以修改商品的图片
  管理员可以设置商品的推荐指数，该指数将影响商品在列表（主页，检索页）上的排名
  访客和用户不可以设置商品的推荐指数，该指数将影响商品在列表（主页，检索页）上的排名
  管理员可以删除商品
  访客和用户不可以删除商品
  管理员,访客,用户不可以手工录入商品

  Background:
    Given There are minimum seeds data
    And There are some sample products

  Scenario: 管理员可以修改商品的展示名, 但不可以修改商品的原始名
    When I log in as "Mighty Admin"
    And I view the details of product "苏北草母鸡"
    And I follow "修改"
    Then I should see "input" whose "id" is "product_name"
    And I should not see "input" whose "id" is "product_original_name"
    When I fill in "product_name" with "新上市草母鸡"
    And I press "完成"
    When I go to the products page
    Then I should see "新上市草母鸡"
    And I should not see "苏北草母鸡"

  Scenario Outline: 管理员,访客,用户不可以手工录入商品
      Given the following vendor exists:
        | name       | city | street |
        | 崇明养殖基地 | 上海 | 崇明 |
      When I log in as "<user>"
      Then I should not see "+产品"
      When I go to the vendors page
      And I follow "崇明养殖基地"
      Then I should not see "+产品"

      Examples:
      | user        |
      | Guest       |
      | David User  |
      | Castle Editor |
      | Mighty Admin     |

    Scenario Outline: Guest and User can't update product
      Given There are some sample products
      When I log in as "<user>"
      And I view the details of product "苏北草母鸡"
      Then I should not see "修改"

      Examples:
      | user        |
      | Guest       |
      | David User  |

    Scenario Outline: Editor and Admin can update product
      When I log in as "<user>"
      And I view the details of product "苏北草母鸡"
      And I follow "修改"
      And I fill in "product_name" with "母鸡变鸭"
      And I press "完成"
      And I go to the products page
      Then I should not see "苏北草母鸡"
      And I should see "母鸡变鸭"

      Examples:
      | user          |
      | Castle Editor |
      | Mighty Admin     |

