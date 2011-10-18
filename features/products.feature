Feature: tests for products
  银筷子提供绿色食品（服务）的信息，比如价格，原文链接等等，并不提供在线购买。
  银筷子会对产品进行一些试吃，食谱推荐等等互动
  用户可以收藏商品，关注商家;
  用户可以对产品进行评论;
  用户会收到产品的降价通知，或其它更新。

  Background:
    Given There are minimum seeds data
    And There are some sample products

  Scenario: Guest can visit the entry of products
    When I go to the products page
    Then I should be on the products page

  Scenario Outline: Everyone else can visit the the entry of products
    When I log in as "<user>"
    And I go to the products page
    Then I should be on the products page

    Examples:
    | user          |
    | David User    |
    | Castle Editor |
    | Ray Admin     |

  Scenario: Guest can't watch a products
    When I go to the products page
    And I follow "苏北草母鸡"
    Then I should not see "+关注"

  Scenario Outline: Everyone else can watch a products
    When I log in as "<user_full_name>"
    And I go to the products page
    And I follow "苏北草母鸡"
    And I follow "+关注"
    And I go to <user_short_name>'s profile page
    Then I should see "苏北草母鸡"

    Examples:
    | user_full_name | user_short_name |
    | David User    | David         |
    | Castle Editor | Castle        |
    | Ray Admin     | Ray           |

  Scenario: One can get vendor's info via product
    And I go to the products page
    And I follow "苏北草母鸡"
    And I follow "南京养鸡场"
    Then I should not see "+关注"

  Scenario Outline: User can watch a vendor via product
    When I log in as "<user_full_name>"
    And I go to the products page
    And I follow "苏北草母鸡"
    And I follow "南京养鸡场"
    And I follow "关注"
    And I go to <user_short_name>'s profile page
    Then I should see "南京养鸡场"

    Examples:
    | user_full_name | user_short_name |
    | David User    | David         |
    | Castle Editor | Castle        |
    | Ray Admin     | Ray           |

  Scenario Outline: Guest and User can't create product
    Given the following vendor exists:
      | name       | city | street |
      | 崇明养殖基地 | 上海 | 崇明 |
    When I go to the vendors page
    And I follow "崇明养殖基地"
    Then I should not see "+产品"

    When I log in as "<user>"
    And I go to the new_product page
    Then I should not be on the new_product page

    Examples:
    | user        |
    | Guest       |
    | David User  |

  Scenario Outline: Editor and Admin can create product
    Given the following vendor exists:
      | name       | city | street |
      | 崇明养殖基地 | 上海 | 崇明 |

    When I log in as "<user>"
    And I go to the vendors page
    And I follow "崇明养殖基地"
    And I follow "+产品"
    And I fill in "product_name" with "崇明毛蟹"
    And I press "完成"
    And I go to the products page
    Then I should see "崇明毛蟹"

    Examples:
    | user          |
    | Castle Editor |
    | Ray Admin     |

  Scenario Outline: Guest and User can't update product
    Given There are some sample products
    When I log in as "<user>"
    And I go to the products page
    And I follow "苏北草母鸡"
    Then I should not see "修改"

    Examples:
    | user        |
    | Guest       |
    | David User  |

  Scenario Outline: Editor and Admin can update product
    When I log in as "<user>"
    And I go to the products page
    And I follow "苏北草母鸡"
    And I follow "修改"
    And I fill in "product_name" with "母鸡变鸭"
    And I press "完成"
    And I go to the products page
    Then I should not see "苏北草母鸡"
    And I should see "母鸡变鸭"

    Examples:
    | user          |
    | Castle Editor |
    | Ray Admin     |

