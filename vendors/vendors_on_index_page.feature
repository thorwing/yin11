# encoding: UTF-8
Feature: products listed on index page
 用户可以访问卖方检索页
 用户可以加关注卖方

  Background:
      Given There are minimum seeds data

  Scenario: Guest can see all vendros
    Given the following vendor exists:
      | name       |
      | 农工商超市 |
    When I go to the vendors page
    Then I should see "农工商超市"