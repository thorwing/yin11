@not
Feature: search for products
     访客可以在主页上搜索到商品
    用户可以在检索页中搜索商品

  Background:
    Given There are minimum seeds data

  Scenario: 访客可以在主页上搜索到商品
    When I search for "梅山猪"
    Then I should see "梅山猪" within ".info_item"


  Scenario: 用户可以在检索页中搜索商品
    When I go to the products page
    And I search for "猪"
    Then I should not see "苏北草母鸡"
    And I should see "梅山猪"