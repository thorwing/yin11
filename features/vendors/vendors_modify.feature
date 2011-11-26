#encoding utf-8
Feature: modify a vendor
  访客和注册用户不可以改变卖方信息
  编辑,管理员可以修改卖方信息

  Background:
    Given There are minimum seeds data
    And There are some products

    Scenario:
