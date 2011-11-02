@focus
Feature: products listed on index page
  访客可以访问商品检索页，看到商品列表(默认按照热门程度，新上架，降价幅度等,展示所有商品。)
  访客可以按照商品的种类，过滤商品。
  访客可以按照商城的送货范围来过滤商品
  访客可以在检索页中搜索商品
  访客可以看到商品的详细信息，包括：名称，来源，价格，规格，原产地，认证信息，介绍，用户评论，以及来源网上商城的配送方式和促销信息
  访客可以在商品展示页看到用户针对商品的分享体验
  访客可以在商品展示页直接分享体验
  访客可以看到（ajax）看到其他用户针对体验的评论

  Background:
    Given There are minimum seeds data
    And There are some sample products

  @focus
  Scenario: 访客可以访问商品检索页，看到商品列表
    When I go to the products page
    Then I should be on the products page

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
    | Mighty Admin     |