#encoding utf-8
Feature: show details of a vendor
  用户可以看到卖方的详细信息,卖方商品

  Background:
    Given There are minimum seeds data
    And There are some products

    Scenario: 用户可以看到卖方的详细信息
       Given the following vendor exists:
      | name   |
      | 天下养鸡网 |
       And I go to the vendors page
      And I follow "天下养鸡网"
      And I should see "天下养鸡网"
      And I should see "苏北草母鸡"


