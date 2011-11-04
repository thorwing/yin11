Feature: products listed on index page
  用户可以访问商品检索页，看到商品列表(默认按照热门程度，新上架，降价幅度等,展示所有商品。)
  用户可以看到商品的分类
  用户可以按照商品的种类，过滤商品。
  用户可以在检索页中搜索商品
  用户可以看到商品的详细信息，包括：名称，来源，价格，规格，原产地，认证信息，介绍，用户评论，以及来源网上商城的配送方式和促销信息
  用户可以在商品展示页看到用户针对商品的分享体验

  Background:
    Given There are minimum seeds data
    And There are some sample products

  Scenario: 用户可以访问商品检索页，看到商品列表
    When I go to the products page
    Then I should be on the products page
    And I should see "div" whose "id" is "products_list"
    And I should see "苏北草母鸡" within "#products_list"

  Scenario: 用户可以看到商品的分类
    Given There are some sample categories
    When I go to the products page
    Then I should see "div" whose "id" is "categories_list"
    Then I should see "肉类" within "#categories_list"
    Then I should see "猪肉" within "#categories_list"

  Scenario: 用户可以按照商品的种类，过滤商品
    Given There are some sample categories
    When I go to the products page
    Then I should see "苏北草母鸡"
    And I should see "梅山猪"
    When I follow "猪肉"
    Then I should not see "苏北草母鸡"
    And I should see "梅山猪"

  Scenario: 用户可以在检索页中搜索商品
    When I go to the products page
    And I search for "猪"
    Then I should not see "苏北草母鸡"
    And I should see "梅山猪"

  Scenario: 用户可以看到商品的详细信息，包括：名称，来源，价格，规格，原产地，认证信息，介绍，用户评论，以及来源网上商城的配送方式和促销信息
    When I view the details of product "苏北草母鸡"
    Then I should see "label" whose id is "product_name"
    Then I should see "label" whose id is "product_area"
    Then I should see "label" whose id is "product_price"
    Then I should see "label" whose id is "product_weight"
    Then I should see "label" whose id is "product_description"
    Then I should see "label" whose id is "product_comments"

    Then I should see "苏北草母鸡"
    And I should see "￥18.00"
    And I should see "一斤"

  Scenario: 用户可以在商品展示页看到用户针对商品的分享体验
    When I log in as "David User"
    And I post a simple review for "苏北草母鸡" with "用来炖鸡汤不错"
    When I log in as "Kate Tester"
    And I view the details of product "苏北草母鸡"
    Then I should see "用来炖鸡汤不错"
