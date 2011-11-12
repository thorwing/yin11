Feature: search for products
  Background:
    Given There are minimum seeds data

  Scenario: 访客可以在主页上搜索到商品
    When I search for "梅山猪"
    Then I should see "梅山猪" within ".info_item"